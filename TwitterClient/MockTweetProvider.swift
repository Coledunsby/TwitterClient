//
//  MockTweetProvider.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-12.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift

struct MockTweetFetcher: TweetFetching {
    
    func fetch() -> Observable<ListChange<Tweet>> {
        let listChanges = (0 ..< 10)
            .map { _ in Tweet.random() }
            .sorted { $0.0.date < $0.1.date }
            .map { ListChange(.insert, $0) }
        
        return Observable.from(listChanges)
    }
}

struct MockTweetPoster: TweetPosting {
    
    func post(_ tweet: Tweet) -> Completable {
        return Completable.empty().delay(1.0, scheduler: MainScheduler.instance)
    }
}

struct MockTweetProvider: TweetProviding {
    
    var fetcher: TweetFetching = MockTweetFetcher()
    var poster: TweetPosting = MockTweetPoster()
}
