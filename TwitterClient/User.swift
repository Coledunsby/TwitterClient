//
//  User.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-06.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RealmSwift
import SwiftRandom

/// Represents a user object in the realm database
final class User: Object {
    
    /// The email address of the user
    dynamic var email: String!
    
    /// The password of the user
    var password: String!
    
    /// The computed handle of the user from their email adress
    var handle: String! {
        return email.components(separatedBy: "@").first
    }
    
    var firstTweet: Tweet? {
        return tweets.sorted(byKeyPath: "date").first
    }
    
    var lastTweet: Tweet? {
        return tweets.sorted(byKeyPath: "date").last
    }
    
    /// A list of the user's tweets
    let tweets = LinkingObjects(fromType: Tweet.self, property: "user")
    
    convenience init(email: String, password: String) {
        self.init()
        self.email = email
        self.password = password
    }
    
    override static func primaryKey() -> String? {
        return "email"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["password"]
    }
}

extension User {
    
    static func random() -> User {
        return User(email: Randoms.email(), password: Randoms.password())
    }
}

private extension Randoms {
    
    static func email() -> String {
        let fakeNames = Randoms.randomFakeName().components(separatedBy: " ")
        let firstName = fakeNames[0].lowercased()
        let lastName = fakeNames[1].lowercased()
        return "\(firstName).\(lastName)@gmail.com"
    }
    
    static func password() -> String {
        let charactersString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()-=_+[]{}|;:,./<>?"
        let characters = Array(charactersString.characters)
        return String((0 ..< 10).flatMap({ _ in characters.randomItem() }))
    }
}
