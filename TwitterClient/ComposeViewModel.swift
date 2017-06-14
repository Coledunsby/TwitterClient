//
//  ComposeViewModel.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-13.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift
import RxSwiftExt

protocol ComposeViewModelInputs {
    
    var text: Variable<String?> { get }
    var tweetSubject: PublishSubject<Void> { get }
    var dismissSubject: PublishSubject<Void> { get }
}

protocol ComposeViewModelOutputs {
    
    var charactersRemainingObservable: Observable<String?> { get }
    var isValidObservable: Observable<Bool> { get }
    var isLoadingObservable: Observable<Bool> { get }
    var dismissObservable: Observable<Void> { get }
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
    let tweetSubject = PublishSubject<Void>()
    let dismissSubject = PublishSubject<Void>()
    
    // MARK: - Outputs
    
    var outputs: ComposeViewModelOutputs {
        return self
    }
    
    let charactersRemainingObservable: Observable<String?>
    let isValidObservable: Observable<Bool>
    let isLoadingObservable: Observable<Bool>
    let dismissObservable: Observable<Void>
    
    // MARK: - Init
    
    init(provider: TweetProvider) {
        let text = self.text.asObservable()
        let dismiss = self.dismissSubject.asObservable()

        let tweet = text.map { message -> Tweet in
            let tweet = Tweet()
            tweet.message = message ?? ""
            tweet.user = User.current
            return tweet
        }
        
        let isLoadingSubject = PublishSubject<Bool>()
        
        let post = tweetSubject
            .withLatestFrom(tweet)
            .flatMapLatest { tweet in
                provider.poster
                    .post(tweet)
                    .asObservable()
                    .mapTo(())
                    .do(onSubscribe: {
                        isLoadingSubject.onNext(true)
                    }, onDispose: {
                        isLoadingSubject.onNext(false)
                    })
            }
        
        charactersRemainingObservable = text.map { "\(140 - ($0?.characters.count ?? 0))" }
        isValidObservable = text.map { !($0?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true) }
        isLoadingObservable = isLoadingSubject
        dismissObservable = Observable.merge([dismiss, post])
    }
}
