//
//  TweetTests.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-21.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RealmSwift
import XCTest

@testable import TwitterClient

final class TweetTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "test database"
    }
    
    func testConvenienceInitializer() {
        let user = User.random()
        let message = "test"
        let date = Date()
        let tweet = Tweet(user: user, message: message, date: date)
        XCTAssertEqual(tweet.user, user)
        XCTAssertEqual(tweet.message, message)
        XCTAssertEqual(tweet.date, date)
    }
    
    func testUserRelationship() {
        let user = User.random()
        
        let tweet = Tweet.random()
        tweet.user = user
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(tweet)
        }
        
        let tweetFromDatabase = realm.objects(Tweet.self).last
        XCTAssertEqual(tweetFromDatabase?.user, user)
    }
}
