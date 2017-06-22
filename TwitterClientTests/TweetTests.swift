//
//  TweetTests.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-21.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import XCTest

@testable import TwitterClient

final class TweetTests: XCTestCase {
    
    func testConvenienceInitializer() {
        let user = User.random()
        let message = "test"
        let date = Date()
        let tweet = Tweet(user: user, message: message, date: date)
        XCTAssertEqual(tweet.user, user)
        XCTAssertEqual(tweet.message, message)
        XCTAssertEqual(tweet.date, date)
    }
}
