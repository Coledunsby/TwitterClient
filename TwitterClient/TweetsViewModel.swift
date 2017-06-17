//
//  TweetsViewModel.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-06.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift
import RxSwiftExt

extension PrimitiveSequence where TraitType == CompletableTrait {
    
    public func asSingle() -> Single<Void> {
        return self
            .asObservable()
            .mapTo(())
            .concat(Observable.just(()))
            .asSingle()
    }
}

protocol TweetsViewModelInputs {
    
    var logout: PublishSubject<Void> { get }
}

protocol TweetsViewModelOutputs {
    
    var sections: Observable<[Section<Tweet>]> { get }
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
    
    let user = Variable<User?>(nil)
    let logout = PublishSubject<Void>()
    
    // MARK: - Outputs
    
    var outputs: TweetsViewModelOutputs {
        return self
    }
    
    // MARK: - Init
    
    let sections: Observable<[Section<Tweet>]>
    let loggedOut: Observable<Void>
    
    init(provider: TweetProviding) {
        var section = Section<Tweet>()
        
        sections = provider.fetcher
            .fetch()
            .map {
                $0.performOperation(on: &section)
                return [section]
            }
        
        loggedOut = logout
            .flatMap {
                Config.loginProvider
                    .logout()
                    .asSingle()
            }
    }
}
