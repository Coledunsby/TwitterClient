//
//  TweetsViewModel.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-06.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift
import RxSwiftExt

protocol TweetsViewModelInputs {
    
    var user: Variable<User?> { get }
    var logoutSubject: PublishSubject<Void> { get }
}

protocol TweetsViewModelOutputs {
    
    var tweetsObservable: Observable<TweetChangeset> { get }
    var loggedOutObservable: Observable<Void> { get }
}

protocol TweetsViewModelIO {
    
    var inputs: TweetsViewModelInputs { get }
    var outputs: TweetsViewModelOutputs { get }
}

struct TweetsViewModel: TweetsViewModelIO, TweetsViewModelInputs, TweetsViewModelOutputs {
    
    // MARK: - Inputs
    
    var inputs: TweetsViewModelInputs {
        return self
    }
    
    let user = Variable<User?>(nil)
    let logoutSubject = PublishSubject<Void>()
    
    // MARK: - Outputs
    
    var outputs: TweetsViewModelOutputs {
        return self
    }
    
    // MARK: - Init
    
    let tweetsObservable: Observable<TweetChangeset>
    var loggedOutObservable: Observable<Void>
    
    init(provider: TweetProvider) {
        tweetsObservable = provider.fetcher.fetch()
        
        
//        tweetsObservable = user
//            .asObservable()
//            .unwrap()
//            .flatMapLatest { user -> Observable<TweetRealmChangeset> in
//                let tweets = user.tweets.sorted(byKeyPath: "date", ascending: false)
//                return Observable.changeset(from: tweets)
//            }
        
        loggedOutObservable = logoutSubject.do(onNext: {
//            User.logout()
        })
    }
}
