//
//  Cache.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-19.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RealmSwift
import RxRealm
import RxSwift

final class Cache {
    
    typealias TweetChangeset = (AnyRealmCollection<Tweet>, RealmChangeset?)
    
    static let shared = Cache()
    private static let userDefaultsKey = "email"
    
    private var _user = Variable<User?>(nil)
    
    var user: User? {
        get {
            return _user.value
        }
        set {
            if let newUser = newValue {
                UserDefaults.standard.set(newUser.email, forKey: Cache.userDefaultsKey)
            } else {
                UserDefaults.standard.removeObject(forKey: Cache.userDefaultsKey)
            }
            _user.value = newValue
        }
    }
    
    let tweets: Observable<TweetChangeset>
    
    init() {
        if let email = UserDefaults.standard.string(forKey: Cache.userDefaultsKey) {
            let realm = try! Realm()
            _user.value = realm.object(ofType: User.self, forPrimaryKey: email)
        }
        
        tweets = _user
            .asObservable()
            .flatMap { user -> Observable<TweetChangeset> in
                guard let user = user else { return .empty() }
                return Observable.changeset(from: user.tweets.sorted(byKeyPath: "date"))
            }
    }
    
    func addTweet(_ tweet: Tweet) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(tweet)
        }
    }
}
