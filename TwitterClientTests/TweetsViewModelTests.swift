//
//  TweetsViewModelTests.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-20.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import XCTest
@testable import TwitterClient

final class TweetsViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialization() {
        let user = User()
        let loginProvider = LocalLoginProvider().asAnyLoginProvider()
        let tweetProvider = LocalTweetProvider(user: user)
        let tweetsViewModel = TweetsViewModel(loginProvider: loginProvider, tweetProvider: tweetProvider)
        XCTAssertNotNil(tweetsViewModel, "The tweets view model should not be nil.")
    }
}
