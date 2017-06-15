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
    
    func fetch() -> Observable<ListChange<Tweet>> {
        let tweets = User.current!.tweets.sorted(byKeyPath: "date", ascending: false)
        return Observable.changeset(from: tweets).flatMap { tweets, changeset -> Observable<ListChange<Tweet>> in
            var listChanges = [ListChange<Tweet>]()
            listChanges.append(contentsOf: changeset?.deleted.map({ ListChange(.delete, tweets[$0]) }) ?? [])
            listChanges.append(contentsOf: changeset?.updated.map({ ListChange(.update, tweets[$0]) }) ?? [])
            listChanges.append(contentsOf: changeset?.inserted.map({ ListChange(.insert, tweets[$0]) }) ?? [])
            return Observable.from(listChanges)
        }
    }
}

struct RealmTweetPoster: TweetPosting {
    
    func post(_ tweet: Tweet) -> Completable {
        return .empty()
    }
}
