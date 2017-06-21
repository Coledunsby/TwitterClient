//
//  LoginViewModel.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-05.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxCocoa
import RxSwift

protocol LoginViewModelInputs {
    
    var email: Variable<String?> { get }
    var password: Variable<String?> { get }
    var login: PublishSubject<Void> { get }
}

protocol LoginViewModelOutputs {
    
    var isLoading: Driver<Bool> { get }
    var tweetsViewModel: Driver<TweetsViewModel> { get }
    var errors: Driver<Error> { get }
}

protocol LoginViewModelIO {
    
    var inputs: LoginViewModelInputs { get }
    var outputs: LoginViewModelOutputs { get }
}

struct LoginViewModel: LoginViewModelIO, LoginViewModelInputs, LoginViewModelOutputs {
    
    // MARK: - Inputs
    
    var inputs: LoginViewModelInputs {
        return self
    }
    
    let email = Variable<String?>(nil)
    let password = Variable<String?>(nil)
    let login = PublishSubject<Void>()
    
    // MARK: - Outputs
    
    var outputs: LoginViewModelOutputs {
        return self
    }
    
    let isLoading: Driver<Bool>
    let tweetsViewModel: Driver<TweetsViewModel>
    let errors: Driver<Error>
    
    // MARK: - Init
    
    init() {
        let email = self.email.asDriver().unwrap().map { $0.lowercased() }
        let password = self.password.asDriver().unwrap()
        let emailAndPassword = Driver.combineLatest(email, password) { ($0, $1) }
        let credentials = emailAndPassword.map { LoginCredentials(email: $0, password: $1) }
        
        let provider = LocalLoginProvider().asAnyLoginProvider()
        let isLoadingSubject = PublishSubject<Bool>()
        
        isLoading = isLoadingSubject
            .asDriver(onErrorJustReturn: false)
        
        tweetsViewModel = Cache.shared.user
            .asDriver(onErrorJustReturn: nil)
            .unwrap()
            .map { TweetsViewModel(loginProvider: provider, tweetProvider: LocalTweetProvider(user: $0)) }
        
        errors = login
            .withLatestFrom(credentials)
            .flatMapLatest { credentials in
                provider
                    .login(with: credentials)
                    .do(onNext: { user in
                        Cache.shared.setCurrentUser(user)
                    }, onSubscribe: {
                        isLoadingSubject.onNext(true)
                    }, onDispose: {
                        isLoadingSubject.onNext(false)
                    })
                    .asObservable()
                    .materialize()
                    .errors()
            }
            .asOptional()
            .asDriver(onErrorJustReturn: nil)
            .unwrap()
    }
}
