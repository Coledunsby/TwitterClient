//
//  RealmTweetProvider.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-12.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RealmSwift
import RxSwift

struct RealmTweetFetcher: TweetFetching {
    
    func fetch() -> Observable<[Tweet]> {
        return .just([])
    }
}

struct RealmTweetPoster: TweetPosting {
    
    func post(_ tweet: Tweet) -> Completable {
        return .never()
    }
}
