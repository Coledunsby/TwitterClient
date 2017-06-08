//
//  LoginProvider.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-08.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift

extension String {
    
    func isValidEmail() -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
}

enum LoginError: LocalizedError {
    
    case invalidEmail
    case invalidPassword
    case invalidCredentials
    case notImplemented
    
    var errorDescription: String {
        switch self {
        case .invalidEmail:
            return "Email address is invalid."
        case .invalidPassword:
            return "Password is invalid."
        case .invalidCredentials:
            return "Credentials are invalid."
        case .notImplemented:
            return "Login provider not implemented."
        }
    }
}

enum LoginProvider {
    
    case email(email: String, password: String)
    
    func login() -> Single<User> {
        switch self {
        case .email(let email, let password):
            guard email.isValidEmail() else { return .error(LoginError.invalidEmail) }
            guard password.characters.count >= 6 else { return .error(LoginError.invalidPassword) }
            // get user
            return Single.just(User()).delay(1.0, scheduler: MainScheduler.instance)
        }
    }
}
