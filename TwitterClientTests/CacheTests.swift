//
//  CacheTests.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-22.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RealmSwift
import XCTest

@testable import TwitterClient

final class CacheTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "test database"
        
        Cache.shared.clear()
    }
    
    func testRestoreFromUserDefaults() {
        let user = User.random()
        
        UserDefaults.standard.set(user.email, forKey: Cache.userDefaultsKey)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(user)
        }
        
        Cache.shared.restoreFromUserDefaults()
        
        XCTAssertEqual(Cache.shared.user, user)
    }
    
    func testSetCurrentUser() {
        let user = User.random()
        
        Cache.shared.setCurrentUser(user)
        
        XCTAssertEqual(UserDefaults.standard.string(forKey: Cache.userDefaultsKey), user.email)
        XCTAssertEqual(Cache.shared.user, user)
    }
    
    func testAddUser() {
        let user = User.random()
        
        Cache.shared.addUser(user)
        
        let realm = try! Realm()
        let userFromDatabase = realm.objects(User.self).last
        
        XCTAssertEqual(userFromDatabase, user)
    }
    
    func testGetUser() {
        let user = User.random()
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(user)
        }
        
        let cachedUser = Cache.shared.getUser(withEmail: user.email)
        
        XCTAssertEqual(cachedUser, user)
    }
    
    func testInvalidateCurrentUser() {
        let user = User.random()
        
        Cache.shared.setCurrentUser(user)
        Cache.shared.invalidateCurrentUser()
        
        XCTAssertNil(UserDefaults.standard.object(forKey: Cache.userDefaultsKey))
        XCTAssertNil(Cache.shared.user)
    }
    
    func testAddTweet() {
        let tweet = Tweet.random()
        
        Cache.shared.addTweet(tweet)
        
        let realm = try! Realm()
        let tweetFromDatabase = realm.objects(Tweet.self).last
        
        XCTAssertEqual(tweetFromDatabase, tweet)
    }
    
    func testAddTweets() {
        let tweets = (0 ..< 5).map { _ in Tweet.random() }
        
        Cache.shared.addTweets(tweets)
        
        let realm = try! Realm()
        let tweetsFromDatabase = realm.objects(Tweet.self)
        
        XCTAssertEqual(Array(tweetsFromDatabase), tweets)
    }
    
    func testClear() {
        Cache.shared.setCurrentUser(User.random())
        Cache.shared.addTweet(Tweet.random())
        Cache.shared.clear()
        
        let realm = try! Realm()
        let usersFromDatabase = realm.objects(User.self)
        let tweetsFromDatabase = realm.objects(Tweet.self)
        
        XCTAssertEqual(usersFromDatabase.count, 0)
        XCTAssertEqual(tweetsFromDatabase.count, 0)
        XCTAssertNil(UserDefaults.standard.object(forKey: Cache.userDefaultsKey))
        XCTAssertNil(Cache.shared.user)
    }
}
