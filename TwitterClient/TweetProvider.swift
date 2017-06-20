//
//  TweetProvider.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-12.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift

/// Defines and groups functions related to fetching tweets to be displayed in some form of feed
protocol TweetFetching {
    
    /// Initialize the fetcher with a specific `User`
    ///
    /// - Parameter user: The `User` to fetch tweets for
    init(user: User)
    
    /// Fetches tweets
    ///
    /// - Returns: A `Single` instance delivering the array of new tweets
    func fetch() -> Single<[Tweet]>
}

/// Defines and groups functions related to posting tweets
protocol TweetPosting {
    
    /// Initialize the poster with a specific `User`
    ///
    /// - Parameter user: The `User` to post tweets for
    init(user: User)
    
    /// Posts a tweet
    ///
    /// - Parameter text: The content of the tweet
    /// - Returns: A `Single` instance delivering the new tweet
    func post(_ text: String) -> Single<Tweet>
}

/// Groups the various tweet related operation protocols into a single provider instance
protocol TweetProviding {
    
    /// Initialize the provider with a specific `User`
    ///
    /// - Parameter user: The `User` to provide tweets for
    init(user: User)
    
    var fetcher: TweetFetching { get }
    var poster: TweetPosting { get }
}
