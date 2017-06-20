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
    var compose: PublishSubject<Void> { get }
}

protocol TweetsViewModelOutputs {
    
    var doneLoadingNewer: Observable<Void> { get }
    var composeViewModel: Observable<ComposeViewModel> { get }
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
    let compose = PublishSubject<Void>()
    
    // MARK: - Outputs
    
    var outputs: TweetsViewModelOutputs {
        return self
    }
    
    let doneLoadingNewer: Observable<Void>
    let composeViewModel: Observable<ComposeViewModel>
    let loggedOut: Observable<Void>
    
    // MARK: - Init
    
    init<T>(loginProvider: AnyLoginProvider<T>, tweetProvider: TweetProviding) {
        doneLoadingNewer = loadNewer
            .startWith(())
            .flatMap {
                tweetProvider.fetcher
                    .fetch()
                    .do(onNext: { Cache.shared.addTweets($0) })
                    .mapTo(())
            }
        
        loggedOut = logout
            .flatMap {
                loginProvider
                    .logout()
                    .asSingle()
                    .do(onNext: { Cache.shared.invalidateCurrentUser() })
            }
        
        composeViewModel = compose
            .mapTo(ComposeViewModel(provider: tweetProvider))
    }
}
