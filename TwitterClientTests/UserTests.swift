//
//  UserTests.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-21.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RealmSwift
import XCTest

@testable import TwitterClient

final class UserTests: XCTestCase {
    
    private let user = User(email: "first.last@gmail.com", password: "password")
    
    override func setUp() {
        super.setUp()
        
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "test database"
        
        Cache.shared.clear()
    }
    
    func testConvenienceInitializer() {
        XCTAssertEqual(user.email, "first.last@gmail.com")
        XCTAssertEqual(user.password, "password")
    }
    
    func testHandle() {
        XCTAssertEqual(user.handle, "first.last")
    }
    
    func testFirstTweet() {
        let tweet1 = tweet(date: Date())
        let tweet2 = tweet(date: Date().addingTimeInterval(1))
        Cache.shared.addTweets([tweet1, tweet2])
        XCTAssertEqual(user.firstTweet, tweet1)
    }
    
    func testLastTweet() {
        let tweet1 = tweet(date: Date())
        let tweet2 = tweet(date: Date().addingTimeInterval(1))
        Cache.shared.addTweets([tweet1, tweet2])
        XCTAssertEqual(user.lastTweet, tweet2)
    }
    
    // MARK: - Private Helper Functions
    
    private func tweet(date: Date) -> Tweet {
        return Tweet(user: user, message: "", date: date)
    }
}
