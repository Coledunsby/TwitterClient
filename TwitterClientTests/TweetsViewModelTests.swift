//
//  TweetsViewModelTests.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-20.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RealmSwift
import RxCocoa
import RxSwift
import RxTest
import XCTest

@testable import TwitterClient

final class TweetsViewModelTests: XCTestCase {
    
    var viewModel: TweetsViewModelIO!
    var scheduler: TestScheduler!
    var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "test database"
        
        Cache.shared.clear()
        
        viewModel = TweetsViewModel(loginProvider: LocalLoginProvider().asAnyLoginProvider(), tweetProvider: LocalTweetProvider(user: User()))
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
}
