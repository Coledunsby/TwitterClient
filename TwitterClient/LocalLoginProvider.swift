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
    
    enum Error: LocalizedError {
        
        case invalidEmail
        case invalidPassword
        
        var errorDescription: String? {
            switch self {
            case .invalidEmail:
                return "Email address is invalid."
            case .invalidPassword:
                return "Password is invalid."
            }
        }
    }
    
    let email: String
    let password: String
    
    /// Validate the credentials based on some criteria
    ///
    /// - Throws: an `Error` if the criteria is not met
    func validate() throws {
        guard email.isValidEmail() else { throw Error.invalidEmail }
        guard password.characters.count >= 6 else { throw Error.invalidPassword }
    }
}

/// A login provider
struct LocalLoginProvider: LoginProviding {
    
    typealias Parameter = LoginCredentials
    
    enum Error: LocalizedError {
        
        case invalidCredentials
        
        var errorDescription: String? {
            switch self {
            case .invalidCredentials:
                return "Credentials are invalid."
            }
        }
    }
    
    func login(with parameter: LoginCredentials) -> Single<User> {
        do {
            try parameter.validate()
        } catch {
            return .error(error)
        }
        
        let realm = try! Realm()
        let existingUser = realm.object(ofType: User.self, forPrimaryKey: parameter.email)
        
        // If a user exists with the provided email, check if the passwords match
        if let existingUser = existingUser, existingUser.password != parameter.password {
            return .error(Error.invalidCredentials)
        }
        
        return Single
            .create { single in
                var user: User! = existingUser
                
                // Create a new user if one does not already exist with that email
                if user == nil {
                    user = User()
                    user.email = parameter.email
                    user.password = parameter.password
                }
                
                single(.success(user))
                
                return Disposables.create()
            }
            // Delay 1 second to simulate network conditions
            .delay(1.0, scheduler: MainScheduler.instance)
    }
    
    func logout() -> Completable {
        return .empty()
    }
}
