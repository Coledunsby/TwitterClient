//
//  TweetProvider.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-12.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift

protocol TweetFetching {
    
    init(user: User)
    
    func fetch() -> Single<[Tweet]>
}

protocol TweetPosting {
    
    init(user: User)
    
    func post(_ text: String) -> Single<Tweet>
}

protocol TweetProviding {
    
    init(user: User)
    
    var fetcher: TweetFetching { get }
    var poster: TweetPosting { get }
}
