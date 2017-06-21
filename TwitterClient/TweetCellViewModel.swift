//
//  TweetCellViewModel.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-13.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxCocoa
import RxSwift

protocol TweetCellViewModelInputs {
    
    var tweet: Variable<Tweet?> { get }
}

protocol TweetCellViewModelOutputs {
    
    var userImage: Driver<UIImage?> { get }
    var userHandle: Driver<String?> { get }
    var date: Driver<String?> { get }
    var message: Driver<String?> { get }
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
    
    let userImage: Driver<UIImage?>
    let userHandle: Driver<String?>
    let date: Driver<String?>
    let message: Driver<String?>
    
    // MARK: - Init
    
    init() {
        let tweet = self.tweet.asDriver()
        
        userImage = .just(#imageLiteral(resourceName: "profile"))
        userHandle = tweet.map { $0?.user.handle }
        date = tweet.map { DateFormatter.localizedString(from: $0?.date ?? Date(), dateStyle: .short, timeStyle: .short) }
        message = tweet.map { $0?.message }
    }
}
