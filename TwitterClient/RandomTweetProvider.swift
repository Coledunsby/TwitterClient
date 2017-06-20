//
//  RandomTweetProvider.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-12.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift

struct RandomTweetFetcher: TweetFetching {
    
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    func fetch() -> Single<[Tweet]> {
        return Single
            .create { single in
                let tweets = (0 ..< 10).map { _ in Tweet.random() }
                single(.success(tweets))
                return Disposables.create()
            }
            // Delay 1 second to simulate network conditions
            .delay(1.0, scheduler: MainScheduler.instance)
    }
}

struct RandomTweetPoster: TweetPosting {
    
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    func post(_ text: String) -> Single<Tweet> {
        return Single
            .create { single in
                single(.success(Tweet.random()))
                return Disposables.create()
            }
            // Delay 1 second to simulate network conditions
            .delay(1.0, scheduler: MainScheduler.instance)
    }
}

struct RandomTweetProvider: TweetProviding {
    
    let fetcher: TweetFetching
    let poster: TweetPosting
    
    init(user: User) {
        fetcher = RandomTweetFetcher(user: user)
        poster = RandomTweetPoster(user: user)
    }
}
