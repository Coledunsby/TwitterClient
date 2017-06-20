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
    
    private let _user = Variable<User?>(nil)
    
    let user: Observable<User?>
    let tweets: Observable<TweetChangeset>
    
    init() {
        user = _user.asObservable()
        
        tweets = user
            .unwrap()
            .flatMapLatest { user -> Observable<TweetChangeset> in
                let tweets = user.tweets.sorted(byKeyPath: "date", ascending: false)
                return Observable.changeset(from: tweets)
            }
        
        let realm = try! Realm()
        
//        tweets = Observable.changeset(from: realm.objects(Tweet.self).sorted(byKeyPath: "date", ascending: false))
        
        if let email = UserDefaults.standard.string(forKey: Cache.userDefaultsKey),
            let user = realm.object(ofType: User.self, forPrimaryKey: email) {
            setCurrentUser(user)
        }
    }
    
    func setCurrentUser(_ user: User) {
        UserDefaults.standard.set(user.email, forKey: Cache.userDefaultsKey)
        _user.value = user
    }
    
    func invalidateCurrentUser() {
        UserDefaults.standard.removeObject(forKey: Cache.userDefaultsKey)
        _user.value = nil
    }
    
    func addTweet(_ tweet: Tweet) {
        addTweets([tweet])
    }
    
    func addTweets(_ tweets: [Tweet]) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(tweets.map({ $0.user }), update: true)
            realm.add(tweets)
        }
    }
    
    func clear() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
}
