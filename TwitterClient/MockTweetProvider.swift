//
//  MockTweetProvider.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-12.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift

struct MockTweetFetcher: TweetFetching {
    
    func fetch() -> Observable<[Tweet]> {
        return .just([])
    }
}

struct MockTweetPoster: TweetPosting {
    
    func post(_ tweet: Tweet) -> Completable {
        return .never()
    }
}

struct MockTweetDeleter: TweetDeleting {
    
    func delete(_ tweet: Tweet) -> Completable {
        return .never()
    }
}
