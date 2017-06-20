//
//  User.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-06.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import KeychainSwift
import RealmSwift
import RxSwift
import SwiftRandom

/// Represents a user object in the realm database
final class User: Object {
    
    /// The email address of the user
    dynamic var email: String!
    
    /// The password of the user (from keychain)
    var password: String {
        get { return KeychainSwift().get(email)! }
        set { KeychainSwift().set(newValue, forKey: email) }
    }
    
    /// The computed handle of the user from their email adress
    var handle: String! {
        return email.components(separatedBy: "@").first
    }
    
    /// A list of the user's tweets
    let tweets = LinkingObjects(fromType: Tweet.self, property: "user")
    
    public override static func primaryKey() -> String? {
        return "email"
    }
    
    public override static func ignoredProperties() -> [String] {
        return ["password"]
    }
}

extension User {
    
    static func random() -> User {
        let user = User()
        user.email = Randoms.randomFakeEmail()
        return user
    }
}

private extension Randoms {
    
    static func randomFakeEmail() -> String {
        let fakeNames = Randoms.randomFakeName().components(separatedBy: " ")
        let firstName = fakeNames[0].lowercased()
        let lastName = fakeNames[1].lowercased()
        return "\(firstName).\(lastName)@gmail.com"
    }
}
