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
    
    var loadNewer: PublishSubject<Void> { get }
    var logout: PublishSubject<Void> { get }
}

protocol TweetsViewModelOutputs {
    
    var doneLoadingNewer: Observable<Void> { get }
    var loggedOut: Observable<Void> { get }
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
    
    let loadNewer = PublishSubject<Void>()
    let logout = PublishSubject<Void>()
    
    // MARK: - Outputs
    
    var outputs: TweetsViewModelOutputs {
        return self
    }
    
    let doneLoadingNewer: Observable<Void>
    let loggedOut: Observable<Void>
    
    // MARK: - Init
    
    init<T>(loginProvider: AnyLoginProvider<T>, tweetProvider: TweetProviding) {
        doneLoadingNewer = loadNewer
            .startWith(())
            .flatMap {
                tweetProvider.fetcher
                    .fetch()
                    .do(onNext: { tweets in
                        tweets.forEach { Cache.shared.addTweet($0) }
                    })
                    .mapTo(())
            }
        
        
        loggedOut = logout
            .flatMap {
                loginProvider
                    .logout()
                    .asSingle()
            }
    }
}
