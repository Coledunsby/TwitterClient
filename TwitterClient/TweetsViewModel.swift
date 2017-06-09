//
//  TweetsViewModel.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-06.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RealmSwift
import RxRealm
import RxRealmDataSources
import RxSwift
import RxSwiftExt

typealias TweetRealmChangest = (AnyRealmCollection<Tweet>, RealmChangeset?)

protocol TweetsViewModelInputs {
    
    var userVar: Variable<User?> { get }
    var logoutSubject: PublishSubject<Void> { get }
}

protocol TweetsViewModelOutputs {
    
    var tweetsObservable: Observable<TweetRealmChangest> { get }
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
    
    let userVar = Variable<User?>(nil)
    let logoutSubject = PublishSubject<Void>()
    
    // MARK: - Outputs
    
    var outputs: TweetsViewModelOutputs {
        return self
    }
    
    // MARK: - Init
    
    let tweetsObservable: Observable<TweetRealmChangest>
    var loggedOutObservable: Observable<Void>
    
    init() {
        tweetsObservable = userVar
            .asObservable()
            .unwrap()
            .flatMapLatest { user -> Observable<TweetRealmChangest> in
                let tweets = user.tweets.sorted(byKeyPath: "date", ascending: false)
                return Observable.changeset(from: tweets)
            }
        
        loggedOutObservable = logoutSubject.do(onNext: {
            User.logout()
        })
    }
}
