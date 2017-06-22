//
//  TweetsViewModel.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-06.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift

protocol TweetsViewModelInputs {
    
    var loadNewer: PublishSubject<Void> { get }
    var logout: PublishSubject<Void> { get }
    var compose: PublishSubject<Void> { get }
}

protocol TweetsViewModelOutputs {
    
    var tweets: Observable<TweetChangeset> { get }
    var composeViewModel: Observable<ComposeViewModel> { get }
    var isLoading: Observable<Bool> { get }
    var loggedOut: Observable<Void> { get }
    var errors: Observable<Error> { get }
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
    
    let tweets: Observable<TweetChangeset>
    let composeViewModel: Observable<ComposeViewModel>
    let isLoading: Observable<Bool>
    let loggedOut: Observable<Void>
    let errors: Observable<Error>
    
    // MARK: - Init
    
    init<T>(loginProvider: AnyLoginProvider<T>, tweetProvider: TweetProviding) {
        let isLoadingSubject = PublishSubject<Bool>()
        
        let loadNewer = self.loadNewer
            .startWith(())
            .flatMapLatest {
                tweetProvider.fetcher
                    .fetch()
                    .do(onNext: {
                        Cache.shared.addTweets($0)
                    }, onSubscribe: {
                        isLoadingSubject.onNext(true)
                    }, onDispose: {
                        isLoadingSubject.onNext(false)
                    })
                    .mapTo(())
                    .asObservable()
                    .materialize()
            }
            .share()
        
        let logout = self.logout
            .flatMapLatest {
                loginProvider
                    .logout()
                    .asSingle()
                    .do(onNext: { Cache.shared.invalidateCurrentUser() })
                    .asObservable()
                    .materialize()
            }
            .share()
        
        tweets = Cache.shared.tweets
        isLoading = isLoadingSubject
        loggedOut = logout.elements()
        errors = Observable.merge([loadNewer.errors(), logout.errors()])
        composeViewModel = compose.mapTo(ComposeViewModel(provider: tweetProvider))
    }
}
