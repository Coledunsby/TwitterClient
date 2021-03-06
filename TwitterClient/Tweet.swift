//
//  Tweet.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-05.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RealmSwift
import SwiftRandom

/// Represents a tweet object in the realm database
final class Tweet: Object {
    
    /// The unique identifier of the tweet
    dynamic var id = UUID().uuidString
    
    /// The user who posted the tweet
    dynamic var user: User!
    
    /// The content of the tweet
    dynamic var message = ""
    
    /// The post date of the tweet
    dynamic var date = Date()
    
    convenience init(user: User, message: String, date: Date = Date()) {
        self.init()
        self.user = user
        self.message = message
        self.date = date
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Tweet {
    
    static func random(withUser user: User? = nil) -> Tweet {
        return Tweet(
            user: user ?? User.random(),
            message: (0 ..< Int.random(1, 3)).map({ _ in Randoms.randomFakeConversation() }).joined(separator: " "),
            date: Date.randomWithinDaysBeforeToday(30)
        )
    }
}
