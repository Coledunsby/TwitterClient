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
    
    var emailVar: Variable<String?> { get }
    var passwordVar: Variable<String?> { get }
    var loginSubject: PublishSubject<Void> { get }
}

protocol LoginViewModelOutputs {
    
    var isLoadingObservable: Observable<Bool> { get }
    var successObservable: Observable<Void> { get }
    var errorsObservable: Observable<Error> { get }
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
    
    let emailVar = Variable<String?>(nil)
    let passwordVar = Variable<String?>(nil)
    let loginSubject = PublishSubject<Void>()
    
    // MARK: - Outputs
    
    var outputs: LoginViewModelOutputs {
        return self
    }
    
    let isLoadingObservable: Observable<Bool>
    let successObservable: Observable<Void>
    let errorsObservable: Observable<Swift.Error>
    
    // MARK: - Init
    
    init() {
        let email = emailVar.asObservable()
        let password = passwordVar.asObservable()
        let emailAndPassword = Observable.combineLatest(email, password, resultSelector: { ($0, $1) })
        
        let isLoadingSubject = PublishSubject<Bool>()
        
        let loginComplete = loginSubject
            .withLatestFrom(emailAndPassword)
            .flatMapLatest { email, password in
                User
                    .login(email: email ?? "", password: password ?? "")
                    .asObservable()
                    .mapTo(())
                    .materialize()
                    .do(onSubscribe: {
                        isLoadingSubject.onNext(true)
                    }, onDispose: {
                        isLoadingSubject.onNext(false)
                    })
            }
            .share()
        
        isLoadingObservable = isLoadingSubject
        successObservable = loginComplete.elements()
        errorsObservable = loginComplete.errors()
    }
}
