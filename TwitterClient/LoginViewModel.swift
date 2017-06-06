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
    
    var successObservable: Observable<Void> { get }
    var errorsObservable: Observable<Swift.Error> { get }
}

protocol LoginViewModelIO {
    
    var inputs: LoginViewModelInputs { get }
    var outputs: LoginViewModelOutputs { get }
}

final class LoginViewModel: LoginViewModelIO, LoginViewModelInputs, LoginViewModelOutputs {
    
    enum Error: Swift.Error {
        
        case invalidEmailAddress
        case invalidPassword
    }
    
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
    
    let successObservable: Observable<Void>
    let errorsObservable: Observable<Swift.Error>
    
    // MARK: - Init
    
    init(provider: LoginProviding) {
        let email = emailVar.asObservable()
        let password = passwordVar.asObservable()
        let emailAndPassword = Observable.combineLatest(email, password, resultSelector: { ($0, $1) })
        
        let loginComplete = loginSubject
            .withLatestFrom(emailAndPassword)
            .flatMapLatest { email, password in
                provider.login(email: email ?? "", password: password ?? "")
            }
            .ignoreCompleted()
            .share()
        
        successObservable = loginComplete.ignoreErrors().mapTo(())
        errorsObservable = loginComplete.materialize().errors()
    }
}
