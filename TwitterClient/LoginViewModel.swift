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
    var logInSubject: PublishSubject<Void> { get }
}

protocol LoginViewModelOutputs {
    
    var loginObservable: Observable<Void> { get }
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
    let logInSubject = PublishSubject<Void>()
    
    // MARK: - Outputs
    
    var outputs: LoginViewModelOutputs {
        return self
    }
    
    let loginObservable: Observable<Void>
    
    // MARK: - Init
    
    init(provider: LoginProviding) {
        let email = emailVar.asObservable()
        let password = passwordVar.asObservable()
        let emailAndPassword = Observable.combineLatest(email, password, resultSelector: { ($0, $1) })
        
        let loginComplete = logInSubject
            .withLatestFrom(emailAndPassword)
            .threadLatest { email, password -> Observable<Void> in
                return provider.login(email: email ?? "", password: password ?? "").asObservable().mapTo(())
//                let events = provider.login(email: email ?? "", password: password ?? "").asObservable().materialize()
//                let success = events.ignoreErrors().dematerialize().map { _ in LoginState.complete }
//                let error = events.errors().map { LoginState.error($0) }
//                return Observable.merge([success, error])
            }
            .share()
        
        
    }
}
