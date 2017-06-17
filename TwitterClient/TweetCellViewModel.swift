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
    
    var userImage: Observable<UIImage?> { get }
    var userHandle: Observable<String?> { get }
    var date: Observable<String?> { get }
    var message: Observable<String?> { get }
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
    
    let userImage: Observable<UIImage?>
    let userHandle: Observable<String?>
    let date: Observable<String?>
    let message: Observable<String?>
    
    // MARK: - Init
    
    init() {
        let tweet = self.tweet.asObservable()
        
        userImage = .just(#imageLiteral(resourceName: "profile"))
        userHandle = tweet.map { $0?.user.handle }
        date = tweet.map { DateFormatter.localizedString(from: $0?.date ?? Date(), dateStyle: .short, timeStyle: .short) }
        message = tweet.map { $0?.message }
    }
}
