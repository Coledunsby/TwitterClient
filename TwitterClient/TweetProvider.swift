//
//  TweetProvider.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-12.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift

struct TweetChangeset {
    
    var tweets: [Tweet] = []
    var inserted: [Int] = []
    var updated: [Int] = []
    var deleted: [Int] = []
    
    static func insert(tweets: [Tweet]) -> TweetChangeset {
        var changeset = TweetChangeset()
        changeset.tweets = tweets
        changeset.inserted = tweets.flatMap { tweets.index(of: $0) }
        return changeset
    }
}

protocol TweetFetching {
    
    func fetch() -> Observable<TweetChangeset>
}

protocol TweetPosting {
    
    func post(_ tweet: Tweet) -> Completable
}

enum TweetProvider {
    
    case mock
    case realm
    
    var fetcher: TweetFetching {
        switch self {
        case .mock:
            return MockTweetFetcher()
        case .realm:
            return RealmTweetFetcher()
        }
    }
    
    var poster: TweetPosting {
        switch self {
        case .mock:
            return MockTweetPoster()
        case .realm:
            return RealmTweetPoster()
        }
    }
}
