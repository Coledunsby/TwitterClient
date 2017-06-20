//
//  LoginViewModel.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-05.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift
import RxSwiftExt

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
    
    init<T>(provider: AnyLoginProvider<T>) {
        let email = self.email.asObservable()
        let password = self.password.asObservable()
        let emailAndPassword = Observable.combineLatest(email, password, resultSelector: { ($0, $1) })
        let credentials = emailAndPassword.map { LoginCredentials(email: $0 ?? "", password: $1 ?? "") }
        
        let isLoadingSubject = PublishSubject<Bool>()
        
        let loginComplete = login
            .withLatestFrom(credentials)
            .flatMapLatest { credentials in
                provider
                    .login(with: credentials as! T)
                    .asObservable()
                    .do(onNext: { user in
                        Cache.shared.user = user
                    }, onSubscribe: {
                        isLoadingSubject.onNext(true)
                    }, onDispose: {
                        isLoadingSubject.onNext(false)
                    })
                    .map { TweetsViewModel(loginProvider: provider, tweetProvider: RandomTweetProvider(user: $0)) }
                    .materialize()
            }
            .share()
        
        isLoading = isLoadingSubject
        tweetsViewModel = loginComplete.dematerialize().ignoreErrors()
        errors = loginComplete.errors()
    }
}
