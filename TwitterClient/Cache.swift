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

/// Cache implemented using `Realm`
/// All data passes through the cache before being displayed
/// User is persisted via `UserDefaults`
final class Cache {
    
    // MARK: - Public API
    
    typealias TweetChangeset = (AnyRealmCollection<Tweet>, RealmChangeset?)
    
    /// A shared instance to the `Cache`
    static let shared = Cache()
    
    /// An `Observable` instance delivering the current user
    let user: Observable<User?>
    
    /// An `Observable` instance delivering the tweet changeset for the current user
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
        
//        This was to show tweets from all users
//        tweets = Observable.changeset(from: realm.objects(Tweet.self).sorted(byKeyPath: "date", ascending: false))
        
        /// Check if user was persisted from a previous session
        if let email = UserDefaults.standard.string(forKey: Cache.userDefaultsKey),
            let user = realm.object(ofType: User.self, forPrimaryKey: email) {
            setCurrentUser(user)
        }
    }
    
    /// Set and persist a new current `User`
    ///
    /// - Parameter user: The new current `User`
    func setCurrentUser(_ user: User) {
        UserDefaults.standard.set(user.email, forKey: Cache.userDefaultsKey)
        _user.value = user
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(user, update: true)
        }
    }
    
    /// Invalidate the current `User` and clear from `UserDefaults`
    func invalidateCurrentUser() {
        UserDefaults.standard.removeObject(forKey: Cache.userDefaultsKey)
        _user.value = nil
    }
    
    /// Add a single `Tweet` to the `Cache`
    ///
    /// - Parameter tweet: The `Tweet` to add
    func addTweet(_ tweet: Tweet) {
        addTweets([tweet])
    }
    
    /// Add an array of `Tweet`s to the `Cache`
    ///
    /// - Parameter tweets: The `Tweet`s to add
    func addTweets(_ tweets: [Tweet]) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(tweets.map({ $0.user }), update: true)
            realm.add(tweets)
        }
    }
    
    /// Clear all data from the `Cache`
    /// WARNING this cannot be undone
    func clear() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    // MARK: - Private
    
    /// A `Variable` instance to store the current `User`
    private let _user = Variable<User?>(nil)
    
    /// The key to use to persist the `User` in `UserDefaults`
    private static let userDefaultsKey = "email"
}
