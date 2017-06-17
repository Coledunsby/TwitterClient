//
//  Tweet.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-05.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RealmSwift
import SwiftRandom

final class Tweet: RealmObject {
    
    dynamic var id = UUID().uuidString
    dynamic var user: User!
    dynamic var message = ""
    dynamic var date = Date()
    
    public override static func primaryKey() -> String? {
        return "id"
    }
}

extension Tweet {
    
    static func random() -> Tweet {
        let tweet = Tweet()
        tweet.user = User.random()
        tweet.message = Randoms.randomFakeConversation()
        tweet.date = Date.randomWithinDaysBeforeToday(30)
        return tweet
    }
}
