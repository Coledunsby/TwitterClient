//
//  TweetProvider.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-12.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift

protocol TweetFetching {
    
    func fetch() -> Observable<[Tweet]>
}

protocol TweetPosting {
    
    func post(_ tweet: Tweet) -> Completable
}

protocol TweetDeleting {
    
    func delete(_ tweet: Tweet) -> Completable
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
    
    var deleter: TweetDeleting {
        switch self {
        case .mock:
            return MockTweetDeleter()
        case .realm:
            return RealmTweetDeleter()
        }
    }
}
