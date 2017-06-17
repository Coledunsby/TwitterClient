//
//  Config.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-13.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import Foundation

struct Config {
    
    static let loginProvider = RealmLoginProvider()
    static let tweetProvider = RealmTweetProvider()
    static let userDefaultsKey = "email"
}
