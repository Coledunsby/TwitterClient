//
//  ComposeViewModelTests.swift
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

final class ComposeViewModelTests: XCTestCase {
    
    var viewModel: ComposeViewModelIO!
    var scheduler: TestScheduler!
    var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "test database"
        
        Cache.shared.clear()
        
        viewModel = ComposeViewModel(provider: LocalTweetProvider(user: User()))
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
}
