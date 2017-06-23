//
//  TweetsViewModelTests.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-20.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RealmSwift
import RxCocoa
import RxRealm
import RxSwift
import RxTest
import XCTest

@testable import TwitterClient

final class TweetsViewModelTests: XCTestCase {
    
    private var viewModel: TweetsViewModelIO!
    private var scheduler: TestScheduler!
    private var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "test database"
        
        Cache.shared.clear()
        
        let user = User.random()
        Cache.shared.setCurrentUser(user)
        
        viewModel = TweetsViewModel(loginProvider: LocalLoginProvider().asAnyLoginProvider(), tweetProvider: LocalTweetProvider(user: user))
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    func testLogout() {
        let logout = scheduler.createHotObservable([next(100, ())])
        logout.bind(to: viewModel.inputs.logout).disposed(by: disposeBag)

        let loggedOut = scheduler.createObserver(Void.self)
        let errors = scheduler.createObserver(Error.self)
        viewModel.outputs.loggedOut.bind(to: loggedOut).disposed(by: disposeBag)
        viewModel.outputs.errors.bind(to: errors).disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(loggedOut.events.count, 1)
        XCTAssertEqual(errors.events.count, 0)
    }
    
    func testLoadNewer() {
        let loadNewer = scheduler.createHotObservable([next(100, ())])
        loadNewer.bind(to: viewModel.inputs.loadNewer).disposed(by: disposeBag)
        
        let tweetChangeset = scheduler.createObserver(TweetChangeset.self)
        let errors = scheduler.createObserver(Error.self)
        viewModel.outputs.tweets.bind(to: tweetChangeset).disposed(by: disposeBag)
        viewModel.outputs.errors.bind(to: errors).disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(tweetChangeset.events.count, 2)
        XCTAssertEqual(errors.events.count, 0)
    }
    
    func testCompose() {
        let compose = scheduler.createHotObservable([next(100, ())])
        compose.bind(to: viewModel.inputs.compose).disposed(by: disposeBag)
        
        let composeViewModel = scheduler.createObserver(ComposeViewModel.self)
        let errors = scheduler.createObserver(Error.self)
        viewModel.outputs.composeViewModel.bind(to: composeViewModel).disposed(by: disposeBag)
        viewModel.outputs.errors.bind(to: errors).disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(composeViewModel.events.count, 1)
        XCTAssertEqual(errors.events.count, 0)
    }
}
