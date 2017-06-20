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
    
    /// Log in a user with a parameter
    ///
    /// - Parameter parameter: any parameter (e.g. `LoginCredentials`)
    /// - Returns: A `Single` instance delivering the `User` or emitting an `Error`
    func login(with parameter: Parameter) -> Single<User>
    
    /// Logout the current user
    ///
    /// - Returns: A `Completable` instance emitting a success or an error
    func logout() -> Completable
}

extension LoginProviding {
    
    /// Erases the type of the provider
    ///
    /// - Returns: A type erased login provider
    func asAnyLoginProvider() -> AnyLoginProvider<Parameter> {
        return AnyLoginProvider(self)
    }
}

/// A type erased `LoginProviding`
///
/// Forwards operations to an arbitrary underlying login provider with the same
/// `Parameter` type, hiding the specifics of the underlying login provider type
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
