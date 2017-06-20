//
//  LocalTweetProvider.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-20.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift

struct LocalTweetFetcher: TweetFetching {
    
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    func fetch() -> Single<[Tweet]> {
        return Single
            .just([])
            // Delay 1 second to simulate network conditions
            .delay(1.0, scheduler: MainScheduler.instance)
    }
}

struct LocalTweetPoster: TweetPosting {
    
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    func post(_ text: String) -> Single<Tweet> {
        return Single
            .create { single in
                let tweet = Tweet()
                tweet.message = text
                tweet.user = self.user
                single(.success(tweet))
                return Disposables.create()
            }
            // Delay 1 second to simulate network conditions
            .delay(1.0, scheduler: MainScheduler.instance)
    }
}

struct LocalTweetProvider: TweetProviding {
    
    let fetcher: TweetFetching
    let poster: TweetPosting
    
    init(user: User) {
        fetcher = LocalTweetFetcher(user: user)
        poster = LocalTweetPoster(user: user)
    }
}
