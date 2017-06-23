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
    
    private var viewModel: ComposeViewModelIO!
    private var scheduler: TestScheduler!
    private var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "test database"
        
        Cache.shared.clear()
        
        viewModel = ComposeViewModel(provider: LocalTweetProvider(user: User()))
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    func testCharactersRemaining() {
        let text = scheduler.createHotObservable([
            next(1, "12345"),
            next(2, "0Hv17UXambW7iNBNT0PwoRP0L2aILGYjmbysEL1oOmpUSyaMuxlNt1Uh8tiTzaRIL3jIF5NRMiHVV6ByH0MLI58JcCfUsPi9sSTo4meQYYBeZRtbf4UlRbc3zPyfPRL4QfAbevH73131"),
            next(3, "0Hv17UXambW7iNBNT0PwoRP0L2aILGYjmbysEL1oOmpUSyaMuxlNt1Uh8tiTzaRIL3jIF5NRMiHVV6ByH0MLI58JcCfUsPi9sSTo4meQYYBeZRtbf4UlRbc3zPyfPRL4QfAbevH731312")
        ])
        text.bind(to: viewModel.inputs.text).disposed(by: disposeBag)
        
        let charactersRemaining = scheduler.createObserver(Int.self)
        let isValid = scheduler.createObserver(Bool.self)
        let errors = scheduler.createObserver(Error.self)
        viewModel.outputs.charactersRemaining.drive(charactersRemaining).disposed(by: disposeBag)
        viewModel.outputs.isValid.drive(isValid).disposed(by: disposeBag)
        viewModel.outputs.errors.bind(to: errors).disposed(by: disposeBag)
        
        scheduler.start()
        
        let charactersRemainingExpected = [
            next(0, 140),
            next(1, 135),
            next(2, 0),
            next(3, -1)
        ]
        
        let isValidExpected = [
            next(0, false),
            next(1, true),
            next(2, true),
            next(3, false)
        ]
        
        XCTAssertEqual(charactersRemaining.events, charactersRemainingExpected)
        XCTAssertEqual(isValid.events, isValidExpected)
        XCTAssertEqual(errors.events.count, 0)
    }
    
    func testPost() {
        let post = scheduler.createHotObservable([next(100, ())])
        post.bind(to: viewModel.inputs.tweet).disposed(by: disposeBag)
        
        let shouldDismiss = scheduler.createObserver(Void.self)
        let errors = scheduler.createObserver(Error.self)
        viewModel.outputs.shouldDismiss.bind(to: shouldDismiss).disposed(by: disposeBag)
        viewModel.outputs.errors.bind(to: errors).disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(shouldDismiss.events.count, 1)
        XCTAssertEqual(errors.events.count, 0)
    }
    
    func testDismiss() {
        let dismiss = scheduler.createHotObservable([next(100, ())])
        dismiss.bind(to: viewModel.inputs.dismiss).disposed(by: disposeBag)
        
        let shouldDismiss = scheduler.createObserver(Void.self)
        let errors = scheduler.createObserver(Error.self)
        viewModel.outputs.shouldDismiss.bind(to: shouldDismiss).disposed(by: disposeBag)
        viewModel.outputs.errors.bind(to: errors).disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(shouldDismiss.events.count, 1)
        XCTAssertEqual(errors.events.count, 0)
    }
}
