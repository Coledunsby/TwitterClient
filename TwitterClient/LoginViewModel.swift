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
    var errorsObservable: Observable<Error> { get }
}

protocol LoginViewModelIO {
    
    var inputs: LoginViewModelInputs { get }
    var outputs: LoginViewModelOutputs { get }
}

final class LoginViewModel: LoginViewModelIO, LoginViewModelInputs, LoginViewModelOutputs {
    
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
    
    init() {
        let email = emailVar.asObservable()
        let password = passwordVar.asObservable()
        let emailAndPassword = Observable.combineLatest(email, password, resultSelector: { ($0, $1) })
        
        let loginComplete = loginSubject
            .withLatestFrom(emailAndPassword)
            .flatMapLatest { email, password in
                LoginProvider
                    .email(email: email ?? "", password: password ?? "")
                    .login()
                    .asObservable()
                    .mapTo(())
                    .materialize()
            }
            .share()
        
        successObservable = loginComplete.elements()
        errorsObservable = loginComplete.errors()
    }
}
