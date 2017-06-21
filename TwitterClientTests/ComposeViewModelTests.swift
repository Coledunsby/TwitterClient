//
//  ComposeViewModelTests.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-20.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import XCTest
@testable import TwitterClient

final class ComposeViewModelTests: XCTestCase {
    
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
        let tweetProvider = LocalTweetProvider(user: user)
        let composeViewModel = ComposeViewModel(provider: tweetProvider)
        XCTAssertNotNil(composeViewModel, "The compose view model should not be nil.")
    }
}
