//
//  MockTweetProvider.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-12.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift
import SwiftRandom

private extension Randoms {
    
    static func randomFakeEmail() -> String {
        let fakeNames = Randoms.randomFakeName().components(separatedBy: " ")
        let firstName = fakeNames[0].lowercased()
        let lastName = fakeNames[1].lowercased()
        return "\(firstName).\(lastName)@gmail.com"
    }
}

private extension User {
    
    static func random() -> User {
        let user = User()
        user.email = Randoms.randomFakeEmail()
        return user
    }
}

private extension Tweet {
    
    static func random() -> Tweet {
        let tweet = Tweet()
        tweet.user = User.random()
        tweet.message = Randoms.randomFakeConversation()
        tweet.date = Date.randomWithinDaysBeforeToday(30)
        return tweet
    }
}

struct MockTweetFetcher: TweetFetching {
    
    func fetch() -> Observable<TweetChangeset> {
        let tweets = (0 ..< 10)
            .map { _ in Tweet.random() }
            .sorted { $0.0.date < $0.1.date }
        let changeset = TweetChangeset.insert(tweets: tweets)
        return Observable.just(changeset)
    }
}

struct MockTweetPoster: TweetPosting {
    
    func post(_ tweet: Tweet) -> Completable {
        return .empty()
    }
}
