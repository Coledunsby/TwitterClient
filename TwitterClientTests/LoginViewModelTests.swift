//
//  LoginViewModelTests.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-20.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import XCTest
@testable import TwitterClient
import RxCocoa
import RxSwift
import RxTest

final class LoginViewModelTests: XCTestCase {
    
    var viewModel: LoginViewModelIO!
    var scheduler: TestScheduler!
    var disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        
        Cache.shared.clear()
        
        viewModel = LoginViewModel()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    func testInvalidEmail() {
        let email = scheduler.createHotObservable([next(50, "")])
        let password = scheduler.createHotObservable([next(50, "password")])
        let login = scheduler.createHotObservable([next(100, ())])
        let errors = scheduler.createObserver(Error.self)
        
        bindInputs(email: email, password: password, login: login)
        viewModel.outputs.errors.drive(errors).disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(errors.events.first?.value.element as? LoginError, .invalidEmail)
    }
    
    func testInvalidPassword() {
        let email = scheduler.createHotObservable([next(50, "test@gmail.com")])
        let password = scheduler.createHotObservable([next(50, "")])
        let login = scheduler.createHotObservable([next(100, ())])
        let errors = scheduler.createObserver(Error.self)
        
        bindInputs(email: email, password: password, login: login)
        viewModel.outputs.errors.drive(errors).disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(errors.events.first?.value.element as? LoginError, .invalidPassword)
    }
    
    func testInvalidCredentials() {
        let email = scheduler.createHotObservable([next(50, "test@gmail.com")])
        let password = scheduler.createHotObservable([next(50, "password")])
        let login = scheduler.createHotObservable([next(100, ())])
        let errors = scheduler.createObserver(Error.self)
        
        bindInputs(email: email, password: password, login: login)
        viewModel.outputs.errors.drive(errors).disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(errors.events.first?.value.element as? LoginError, .invalidCredentials)
    }
    
    func testValidCredentials() {
        addUser(email: "test@gmail.com", password: "password")
        
        let email = scheduler.createHotObservable([next(50, "")])
        let password = scheduler.createHotObservable([next(50, "")])
        let login = scheduler.createHotObservable([next(100, ())])
        let tweetsViewModel = scheduler.createObserver(TweetsViewModel.self)
        
        bindInputs(email: email, password: password, login: login)
        viewModel.outputs.tweetsViewModel.drive(tweetsViewModel).disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertNotNil(tweetsViewModel.events.first?.value)
    }
    
    // MARK: - Private Helper Functions
    
    private func addUser(email: String, password: String) {
        let user = User()
        user.email = email
        user.password = password
        Cache.shared.addUser(user)
    }
    
    private func bindInputs(email: TestableObservable<String>, password: TestableObservable<String>, login: TestableObservable<()>) {
        email.bind(to: viewModel.inputs.email).disposed(by: disposeBag)
        password.bind(to: viewModel.inputs.password).disposed(by: disposeBag)
        login.bind(to: viewModel.inputs.login).disposed(by: disposeBag)
    }
}
