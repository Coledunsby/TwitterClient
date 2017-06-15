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
    var logout: PublishSubject<Void> { get }
}

protocol TweetsViewModelOutputs {
    
    var sections: Observable<[Section<Tweet>]> { get }
    var loggedOut: Observable<Void>! { get }
}

protocol TweetsViewModelIO {
    
    var inputs: TweetsViewModelInputs { get }
    var outputs: TweetsViewModelOutputs { get }
}

final class TweetsViewModel: TweetsViewModelIO, TweetsViewModelInputs, TweetsViewModelOutputs {
    
    // MARK: - Private
    
    private let disposeBag = DisposeBag()
    
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
    var loggedOut: Observable<Void>!
    
    init(provider: TweetProvider) {
        var section = Section<Tweet>()
        
        sections = .just([section])
        
        provider.fetcher
            .fetch()
            .do(onNext: { $0.performOperation(on: &section) })
            .subscribe()
            .disposed(by: disposeBag)
        
        loggedOut = logout.do(onNext: {
//            User.logout()
        })
    }
}
