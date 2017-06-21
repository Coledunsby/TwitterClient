//
//  LocalLoginProvider.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-15.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RealmSwift
import RxSwift

extension String {
    
    /// Checks if a given string is a valid email address using a regular expression
    ///
    /// - Returns: `true` if the string is a valid email address, `false` otherwise
    func isValidEmail() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
}

/// A struct to store and validate email-password pairs
struct LoginCredentials {
    
    let email: String
    let password: String
    
    /// Validate the credentials based on some criteria
    ///
    /// - Throws: an `Error` if the criteria is not met
    func validate() throws {
        guard email.isValidEmail() else { throw LoginError.invalidEmail }
        guard password.characters.count >= 6 else { throw LoginError.invalidPassword }
    }
}

/// A login provider
struct LocalLoginProvider: LoginProviding {
    
    typealias Parameter = LoginCredentials
    
    func login(with parameter: LoginCredentials) -> Single<User> {
        do {
            try parameter.validate()
        } catch {
            return .error(error)
        }
        
        let user: User
        let realm = try! Realm()
        
        if let existingUser = realm.object(ofType: User.self, forPrimaryKey: parameter.email) {
            // If a user exists with the provided email, check if the passwords match
            guard existingUser.password == parameter.password else { return .error(LoginError.invalidCredentials) }
            user = existingUser
        } else {
            // Create a new user if one does not already exist with that email
            user = User()
            user.email = parameter.email
            user.password = parameter.password
        }
        
        return Single
            .just(user)
            .simulateNetworkDelay()
    }
    
    func logout() -> Completable {
        return .empty()
    }
}
