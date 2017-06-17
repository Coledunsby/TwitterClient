//
//  RealmLoginProvider.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-15.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RealmSwift
import RxSwift

extension String {
    
    func isValidEmail() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
}

struct RealmLoginCredentials {
    
    enum Error: LocalizedError {
        
        case invalidEmail
        case invalidPassword
        
        var errorDescription: String {
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
    
    func validate() throws {
        guard email.isValidEmail() else { throw Error.invalidEmail }
        guard password.characters.count >= 6 else { throw Error.invalidPassword }
    }
}

struct RealmLoginProvider: LoginProviding {
    
    typealias Parameter = RealmLoginCredentials
    
    enum Error: LocalizedError {
        
        case invalidCredentials
        
        var errorDescription: String {
            switch self {
            case .invalidCredentials:
                return "Credentials are invalid."
            }
        }
    }
    
    private static var user: User?
    
    var currentUser: User? {
        if let user = RealmLoginProvider.user {
            return user
        } else if let email = UserDefaults.standard.string(forKey: Config.userDefaultsKey) {
            let realm = try! Realm()
            return realm.object(ofType: User.self, forPrimaryKey: email)
        }
        return nil
    }
    
    func login(_ parameter: RealmLoginCredentials?) -> Single<User> {
        guard let credentials = parameter else { return Single.error(Error.invalidCredentials) }
        
        do {
            try credentials.validate()
        } catch {
            return Single.error(error)
        }
        
        let realm = try! Realm()
        let user: User
        
        if let existingUser = realm.object(ofType: User.self, forPrimaryKey: credentials.email) {
            guard existingUser.password == credentials.password else {
                return Single.error(Error.invalidCredentials)
            }
            user = existingUser
        } else {
            user = User()
            user.email = credentials.email
            user.password = credentials.password
            try! realm.write {
                realm.add(user)
            }
        }
        
        UserDefaults.standard.set(credentials.email, forKey: Config.userDefaultsKey)
        
        // Wait 1 second to simulate network delay
        return Single.just(user).delay(1.0, scheduler: MainScheduler.instance)
    }
    
    func logout() -> Completable {
        UserDefaults.standard.removeObject(forKey: Config.userDefaultsKey)
        return .empty()
    }
}
