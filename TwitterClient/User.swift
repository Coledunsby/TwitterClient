//
//  User.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-06.
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

enum LoginError: LocalizedError {
    
    case invalidEmail
    case invalidPassword
    case invalidCredentials
    
    var errorDescription: String {
        switch self {
        case .invalidEmail:
            return "Email address is invalid."
        case .invalidPassword:
            return "Password is invalid."
        case .invalidCredentials:
            return "Credentials are invalid."
        }
    }
}

final class User: Object {
    
    dynamic var email: String!
    dynamic var password: String!
    
    let tweets = LinkingObjects(fromType: Tweet.self, property: "user")
    
    public override static func primaryKey() -> String? {
        return "email"
    }
}

extension User {
    
    func tweet(message: String) {
        let tweet = Tweet()
        tweet.id = UUID().uuidString
        tweet.user = self
        tweet.message = message
        tweet.date = Date()
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(tweet)
        }
    }
}

extension User {
    
    static let userDefaultsKey = "email"
    
    static var current: User? {
        guard let email = UserDefaults.standard.string(forKey: userDefaultsKey) else { return nil }
        let realm = try! Realm()
        return realm.object(ofType: User.self, forPrimaryKey: email)
    }
    
    static func login(email: String, password: String) -> Single<User> {
        guard email.isValidEmail() else { return .error(LoginError.invalidEmail) }
        guard password.characters.count >= 6 else { return .error(LoginError.invalidPassword) }
        
        let realm = try! Realm()
        let user: User
        
        if let existingUser = realm.object(ofType: User.self, forPrimaryKey: email) {
            guard existingUser.password == password else {
                return Single.error(LoginError.invalidCredentials).delay(5.0, scheduler: MainScheduler.instance)
            }
            user = existingUser
        } else {
            user = User()
            user.email = email
            user.password = password
            try! realm.write {
                realm.add(user)
            }
        }
        
        UserDefaults.standard.set(email, forKey: User.userDefaultsKey)
        
        // Wait 1 second to simulate network delay
        return Single.just(user).delay(1.0, scheduler: MainScheduler.instance)
    }
    
    static func logout() {
        UserDefaults.standard.removeObject(forKey: User.userDefaultsKey)
    }
}
