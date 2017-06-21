//
//  TweetsViewModel.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-06.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxCocoa
import RxSwift

protocol TweetsViewModelInputs {
    
    var loadNewer: PublishSubject<Void> { get }
    var logout: PublishSubject<Void> { get }
    var compose: PublishSubject<Void> { get }
}

protocol TweetsViewModelOutputs {
    
    var doneLoadingNewer: Driver<Void> { get }
    var composeViewModel: Driver<ComposeViewModel> { get }
    var loggedOut: Driver<Void> { get }
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
    
    let doneLoadingNewer: Driver<Void>
    let composeViewModel: Driver<ComposeViewModel>
    let loggedOut: Driver<Void>
    
    // MARK: - Init
    
    init<T>(loginProvider: AnyLoginProvider<T>, tweetProvider: TweetProviding) {
        doneLoadingNewer = loadNewer
            .asDriver(onErrorJustReturn: ())
            .startWith(())
            .flatMap {
                tweetProvider.fetcher
                    .fetch()
                    .asDriver(onErrorJustReturn: [])
                    .do(onNext: { Cache.shared.addTweets($0) })
                    .mapTo(())
            }
        
        loggedOut = logout
            .asDriver(onErrorJustReturn: ())
            .flatMap {
                loginProvider
                    .logout()
                    .asSingle()
                    .asDriver(onErrorJustReturn: ())
                    .do(onNext: { Cache.shared.invalidateCurrentUser() })
            }
        
        composeViewModel = compose
            .asDriver(onErrorJustReturn: ())
            .mapTo(ComposeViewModel(provider: tweetProvider))
    }
}
