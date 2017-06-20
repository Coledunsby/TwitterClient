//
//  LoginViewModel.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-05.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift

protocol LoginViewModelInputs {
    
    var email: Variable<String?> { get }
    var password: Variable<String?> { get }
    var login: PublishSubject<Void> { get }
}

protocol LoginViewModelOutputs {
    
    var isLoading: Observable<Bool> { get }
    var tweetsViewModel: Observable<TweetsViewModel> { get }
    var errors: Observable<Error> { get }
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
    
    let isLoading: Observable<Bool>
    let tweetsViewModel: Observable<TweetsViewModel>
    let errors: Observable<Error>
    
    // MARK: - Init
    
    init() {
        let email = self.email.asObservable().unwrap()
        let password = self.password.asObservable().unwrap()
        let emailAndPassword = Observable.combineLatest(email, password) { ($0, $1) }
        let credentials = emailAndPassword.map { LoginCredentials(email: $0, password: $1) }
        
        let provider = LocalLoginProvider().asAnyLoginProvider()
        let isLoadingSubject = PublishSubject<Bool>()
        
        isLoading = isLoadingSubject
        
        tweetsViewModel = Cache.shared.user
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
    }
}
