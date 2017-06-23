//
//  LocalTweetProvider.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-20.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift
import SwiftRandom

private extension Date {
    
    /// Return a random date between two dates
    ///
    /// - Parameters:
    ///   - startDate: the start date (min)
    ///   - endDate: the end date (max)
    /// - Returns: a random date between the start and end date
    static func random(startDate: Date, endDate: Date) -> Date {
        let startTimeInterval = startDate.timeIntervalSince1970
        let endTimeInterval = endDate.timeIntervalSince1970
        let difference = endTimeInterval - startTimeInterval
        let random = TimeInterval.random(0, difference)
        return Date(timeIntervalSince1970: startTimeInterval + random)
    }
}

struct LocalTweetFetcher: TweetFetching {
    
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    /// Return a random number (at least 1) of new random tweets after the last cached tweet and before the current date
    func fetch() -> Single<[Tweet]> {
        let lastTweet = user.lastTweet
        
        let newTweets = (1 ..< Int.random(1, 5))
            .map { _ -> Tweet in
                let tweet = Tweet.random()
                tweet.user = user
                tweet.date = Date.random(startDate: lastTweet?.date ?? Date.randomWithinDaysBeforeToday(30), endDate: Date())
                return tweet
            }
            .sorted(by: { $0.date < $1.date })
        
        return Single
            .just(newTweets)
            .simulateNetworkDelay()
    }
}

struct LocalTweetPoster: TweetPosting {
    
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    func post(_ text: String) -> Single<Tweet> {
        return Single
            .just(Tweet(user: user, message: text))
            .simulateNetworkDelay()
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
