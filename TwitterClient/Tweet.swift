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
    
    public override static func primaryKey() -> String? {
        return "id"
    }
}

extension Tweet {
    
    static func random(newerThan: Date = Date()) -> Tweet {
        let tweet = Tweet()
        tweet.user = User.random()
        tweet.message = Randoms.randomFakeConversation()
        tweet.date = Date.randomWithinDaysBeforeToday(30)
        return tweet
    }
}
