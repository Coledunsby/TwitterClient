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
    var isLoading: Driver<Bool> { get }
    var shouldDismiss: Driver<Void> { get }
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
    let isLoading: Driver<Bool>
    let shouldDismiss: Driver<Void>
    
    // MARK: - Init
    
    init(provider: TweetProviding) {
        let text = self.text.asDriver()
        let dismiss = self.dismiss.asDriver(onErrorJustReturn: ())
        
        let isLoadingSubject = PublishSubject<Bool>()
        
        let post = tweet
            .asDriver(onErrorJustReturn: ())
            .withLatestFrom(text)
            .flatMapLatest { text in
                provider.poster
                    .post(text ?? "")
                    .asOptional()
                    .asDriver(onErrorJustReturn: nil)
                    .unwrap()
                    .do(onNext: { tweet in
                        Cache.shared.addTweet(tweet)
                    }, onSubscribe: {
                        isLoadingSubject.onNext(true)
                    }, onDispose: {
                        isLoadingSubject.onNext(false)
                    })
                    .mapTo(())
            }
        
        charactersRemaining = text.map { 140 - ($0?.characters.count ?? 0) }
        isValid = charactersRemaining.map { (0 ..< 140) ~= $0 }
        isLoading = isLoadingSubject.asDriver(onErrorJustReturn: false)
        shouldDismiss = Driver.merge([dismiss, post])
    }
}
