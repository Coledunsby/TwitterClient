//
//  Config.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-13.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import Foundation

struct Config {
    
    static let shared = Config()
    
    let tweetProvider = TweetProvider.realm
}
