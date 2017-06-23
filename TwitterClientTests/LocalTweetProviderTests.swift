//
//  LocalTweetProviderTests.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-22.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift
import RxTest
import XCTest

@testable import TwitterClient

final class LocalTweetProviderTests: XCTestCase {
    
    private var provider: LocalTweetProvider!
    private var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        provider = LocalTweetProvider(user: User.random())
        disposeBag = DisposeBag()
    }
    
    func testFetch() {
        let expectation = self.expectation(description: "fetch tweets")
        
        provider.fetcher
            .fetch()
            .subscribe(onSuccess: { tweets in
                XCTAssertTrue((1 ... 5) ~= tweets.count)
                expectation.fulfill()
            }, onError: { error in
                XCTFail(error.localizedDescription)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testPost() {
        let expectation = self.expectation(description: "fetch tweets")
        
        provider.poster
            .post("test")
            .subscribe(onSuccess: { tweet in
                XCTAssertEqual(tweet.message, "test")
                expectation.fulfill()
            }, onError: { error in
                XCTFail(error.localizedDescription)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
}
