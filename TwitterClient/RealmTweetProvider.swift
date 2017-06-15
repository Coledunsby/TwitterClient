//
//  RealmTweetProvider.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-12.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RealmSwift
import RxRealm
import RxSwift

struct RealmTweetFetcher: TweetFetching {
    
    func fetch() -> Observable<TweetChangeset> {
        let tweets = User.current!.tweets.sorted(byKeyPath: "date", ascending: false)
        return Observable.changeset(from: tweets).map { tweets, realmChangset in
            var changeset = TweetChangeset()
            changeset.tweets = tweets.toArray()
            changeset.inserted = realmChangset?.inserted ?? []
            changeset.updated = realmChangset?.updated ?? []
            changeset.deleted = realmChangset?.deleted ?? []
            return changeset
        }
    }
}

struct RealmTweetPoster: TweetPosting {
    
    func post(_ tweet: Tweet) -> Completable {
        return .empty()
    }
}
