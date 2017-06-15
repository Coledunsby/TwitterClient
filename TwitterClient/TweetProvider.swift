//
//  TweetProvider.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-12.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift

protocol TweetFetching {
    
    func fetch() -> Observable<ListChange<Tweet>>
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
