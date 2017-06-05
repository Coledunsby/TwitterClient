//
//  LoginProvider.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-05.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift

protocol LoginProviding {
    
    func login(email: String, password: String) -> Completable
}
