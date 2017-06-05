//
//  MockLoginProvider.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-05.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift

struct MockLoginProvider: LoginProviding {
    
    func login(email: String, password: String) -> Completable {
        return Completable.empty().delay(1.0, scheduler: MainScheduler.instance)
    }
}
