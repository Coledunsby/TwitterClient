//
//  ComposeViewModel.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-13.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxCocoa
import RxSwift

protocol ComposeViewModelInputs {
    
    var text: Variable<String?> { get }
    var tweet: PublishSubject<Void> { get }
    var dismiss: PublishSubject<Void> { get }
}

protocol ComposeViewModelOutputs {
    
    var charactersRemaining: Driver<Int> { get }
    var isValid: Driver<Bool> { get }
    var isLoading: Observable<Bool> { get }
    var shouldDismiss: Observable<Void> { get }
}

protocol ComposeViewModelIO {
    
    var inputs: ComposeViewModelInputs { get }
    var outputs: ComposeViewModelOutputs { get }
}

struct ComposeViewModel: ComposeViewModelIO, ComposeViewModelInputs, ComposeViewModelOutputs {
    
    // MARK: - Inputs
    
    var inputs: ComposeViewModelInputs {
        return self
    }
    
    let text = Variable<String?>(nil)
    let tweet = PublishSubject<Void>()
    let dismiss = PublishSubject<Void>()
    
    // MARK: - Outputs
    
    var outputs: ComposeViewModelOutputs {
        return self
    }
    
    let charactersRemaining: Driver<Int>
    let isValid: Driver<Bool>
    let isLoading: Observable<Bool>
    let shouldDismiss: Observable<Void>
    
    // MARK: - Init
    
    init(provider: TweetProviding) {
        let text = self.text.asDriver()
        let dismiss = self.dismiss.asObservable()
        
        let isLoadingSubject = PublishSubject<Bool>()
        
        let post = tweet
            .withLatestFrom(text)
            .threadLatest { text in
                provider.poster
                    .post(text ?? "")
                    .do(onNext: { tweet in
                        Cache.shared.addTweet(tweet)
                    }, onSubscribe: {
                        isLoadingSubject.onNext(true)
                    }, onDispose: {
                        isLoadingSubject.onNext(false)
                    })
                    .mapTo(())
            }
            .ignoreErrors()
        
        charactersRemaining = text.map { 140 - ($0?.characters.count ?? 0) }
        isValid = charactersRemaining.map { (0 ..< 140) ~= $0 }
        isLoading = isLoadingSubject
        shouldDismiss = Observable.merge([dismiss, post])
    }
}
