//
//  RandomLoginProvider.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-19.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift

struct RandomLoginProvider: LoginProviding {
    
    typealias Parameter = Void
    
    func login(with parameter: Void) -> Single<User> {
        return .just(User.random())
    }
    
    func logout() -> Completable {
        return .empty()
    }
}
