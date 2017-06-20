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
    
    func isValidEmail() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
}

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
    
    func validate() throws {
        guard email.isValidEmail() else { throw Error.invalidEmail }
        guard password.characters.count >= 6 else { throw Error.invalidPassword }
    }
}

struct MockLoginProvider: LoginProviding {
    
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
        
        if let existingUser = existingUser, existingUser.password != parameter.password {
            return .error(Error.invalidCredentials)
        }
        
        return Single
            .create { single in
                var user: User! = existingUser
                
                if user == nil {
                    user = User()
                    user.email = parameter.email
                    user.password = parameter.password
                    try! realm.write {
                        realm.add(user)
                    }
                }
                
                single(.success(user))
                
                return Disposables.create()
            }
            .delay(1.0, scheduler: MainScheduler.instance)
    }
    
    func logout() -> Completable {
        return .empty()
    }
}
