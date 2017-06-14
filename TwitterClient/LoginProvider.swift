//
//  LoginProvider.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-12.
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

protocol LoginProviding {
    
    func login() -> Single<User>
    func logout() -> Completable
}

struct LoginCredentials {
    
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

enum LoginProvider: LoginProviding {
    
    enum Error: LocalizedError {
        
        case invalidCredentials
        
        var errorDescription: String {
            switch self {
            case .invalidCredentials:
                return "Credentials are invalid."
            }
        }
    }
    
    static let userDefaultsKey = "email"
    
    case mock
    case realm(LoginCredentials)
    
    func login() -> Single<User> {
        switch self {
        case .mock:
            let user = User()
            user.email = ""
            user.password = "password"
            // Wait 1 second to simulate network delay
            return Single.just(user).delay(1.0, scheduler: MainScheduler.instance)
        case .realm(let credentials):
            do {
                try credentials.validate()
            } catch {
                return Single.error(error)
            }
            
            let realm = try! Realm()
            let user: User
            
            if let existingUser = realm.object(ofType: User.self, forPrimaryKey: credentials.email) {
                guard existingUser.password == credentials.password else {
                    return Single.error(Error.invalidCredentials).delay(1.0, scheduler: MainScheduler.instance)
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
            
            UserDefaults.standard.set(credentials.email, forKey: LoginProvider.userDefaultsKey)
            
            // Wait 1 second to simulate network delay
            return Single.just(user).delay(1.0, scheduler: MainScheduler.instance)
        }
    }
    
    func logout() -> Completable {
        switch self {
        case .mock:
            return .never()
        case .realm:
            UserDefaults.standard.removeObject(forKey: LoginProvider.userDefaultsKey)
            return .never()
        }
    }
}
