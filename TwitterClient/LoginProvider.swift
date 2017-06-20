//
//  LoginProvider.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-12.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift

protocol LoginProviding {
    
    associatedtype Parameter
    
    func login(with parameter: Parameter) -> Single<User>
    func logout() -> Completable
}

extension LoginProviding {
    
    func asAnyLoginProvider() -> AnyLoginProvider<Parameter> {
        return AnyLoginProvider(self)
    }
}

struct AnyLoginProvider<T>: LoginProviding {
    
    private let _login: (_ parameter: T) -> Single<User>
    private let _logout: () -> Completable
    
    init<U: LoginProviding>(_ loginProviding: U) where U.Parameter == T {
        _login = loginProviding.login
        _logout = loginProviding.logout
    }
    
    func login(with parameter: T) -> Single<User> {
        return _login(parameter)
    }
    
    func logout() -> Completable {
        return _logout()
    }
}
