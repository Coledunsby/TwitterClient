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
    
    var userImageObservable: Observable<UIImage?> {
        return .just(nil)
    }
    
    var userHandleObservable: Observable<String?> {
        return tweet.asObservable().map { $0?.user.email.components(separatedBy: "@").first }
    }
    
    var dateObservable: Observable<String?> {
        return tweet.asObservable().map { DateFormatter.localizedString(from: $0?.date ?? Date(), dateStyle: .short, timeStyle: .none) }
    }
    
    var messageObservable: Observable<String?> {
        return tweet.asObservable().map { $0?.message }
    }
}
