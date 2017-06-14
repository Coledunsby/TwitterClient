//
//  TweetCellViewModel.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-13.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift

protocol TweetCellViewModelInputs {
    
    var tweet: Variable<Tweet?> { get }
}

protocol TweetCellViewModelOutputs {
    
    var userImageObservable: Observable<UIImage?> { get }
    var userHandleObservable: Observable<String?> { get }
    var dateObservable: Observable<String?> { get }
    var messageObservable: Observable<String?> { get }
}

protocol TweetCellViewModelIO {
    
    var inputs: TweetCellViewModelInputs { get }
    var outputs: TweetCellViewModelOutputs { get }
}

struct TweetCellViewModel: TweetCellViewModelIO, TweetCellViewModelInputs, TweetCellViewModelOutputs {
    
    // MARK: - Inputs
    
    var inputs: TweetCellViewModelInputs {
        return self
    }
    
    let tweet = Variable<Tweet?>(nil)
    
    // MARK: - Outputs
    
    var outputs: TweetCellViewModelOutputs {
        return self
    }
    
    let userImageObservable: Observable<UIImage?>
    let userHandleObservable: Observable<String?>
    let dateObservable: Observable<String?>
    let messageObservable: Observable<String?>
    
    // MARK: - Init
    
    init() {
        let tweet = self.tweet.asObservable()
        
        userImageObservable = .just(nil)
        userHandleObservable = tweet.map { $0?.user.handle }
        dateObservable = tweet.map { DateFormatter.localizedString(from: $0?.date ?? Date(), dateStyle: .short, timeStyle: .none) }
        messageObservable = tweet.map { $0?.message }
    }
}
