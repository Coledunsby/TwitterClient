//
//  MockLoginProvider.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-15.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift

struct MockLoginProvider: LoginProviding {
    
    private static var user: User?
    
    typealias Parameter = String
    
    var currentUser: User? {
        if let user = MockLoginProvider.user {
            return user
        } else if let email = UserDefaults.standard.string(forKey: Config.userDefaultsKey) {
            let user = User()
            user.email = email
            return user
        }
        return nil
    }
    
    func login(_ parameter: String?) -> Single<User> {
        let user = User.random()
        MockLoginProvider.user = user
        UserDefaults.standard.set(user.email, forKey: Config.userDefaultsKey)
        // Wait 1 second to simulate network delay
        return Single.just(user).delay(1.0, scheduler: MainScheduler.instance)
    }
    
    func logout() -> Completable {
        MockLoginProvider.user = nil
        UserDefaults.standard.removeObject(forKey: Config.userDefaultsKey)
        return .empty()
    }
}
