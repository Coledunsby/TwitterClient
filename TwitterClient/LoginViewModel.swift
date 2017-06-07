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
    
    var loginSubject: PublishSubject<LoginProvider> { get }
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
    
    // MARK: - Inputs
    
    var inputs: LoginViewModelInputs {
        return self
    }
    
    let loginSubject = PublishSubject<LoginProvider>()
    
    // MARK: - Outputs
    
    var outputs: LoginViewModelOutputs {
        return self
    }
    
    let successObservable: Observable<Void>
    let errorsObservable: Observable<Swift.Error>
    
    // MARK: - Init
    
    init() {
        let loginComplete = loginSubject
            .flatMapLatest { $0.login().asObservable().mapTo(()).materialize() }
            .share()
        
        successObservable = loginComplete.elements()
        errorsObservable = loginComplete.errors()
    }
}
