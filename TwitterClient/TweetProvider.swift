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

protocol TweetProviding {
    
    var fetcher: TweetFetching { get }
    var poster: TweetPosting { get }
}
