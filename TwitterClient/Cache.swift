//
//  Cache.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-19.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import KeychainSwift
import RealmSwift
import RxRealm
import RxSwift

/// Cache implemented using `Realm`
/// All data passes through the cache before being displayed
/// State (e.g. current user) is persisted via `UserDefaults`
/// Sensitive information (e.g. passwords) are persisted via the keychain
final class Cache {
    
    // MARK: - Private
    
    private let keychain = KeychainSwift()
    
    /// A `Variable` instance to store the current `User`
    private let _user = Variable<User?>(nil)
    
    /// The key to use to persist the `User` in `UserDefaults`
    private static let userDefaultsKey = "email"
    
    // MARK: - Public API
    
    typealias TweetChangeset = (AnyRealmCollection<Tweet>, RealmChangeset?)
    
    /// A shared instance to the `Cache`
    static let shared = Cache()
    
    /// The current `User`
    var user: User? { return _user.value }
    
    /// An `Observable` instance delivering the tweet changeset for the current user
    let tweets: Observable<TweetChangeset>
    
    init() {
        tweets = _user
            .asObservable()
            .unwrap()
            .flatMapLatest { user -> Observable<TweetChangeset> in
                let tweets = user.tweets.sorted(byKeyPath: "date", ascending: false)
                return Observable.changeset(from: tweets)
            }
        
//        This was to show tweets from all users
//        tweets = Observable.changeset(from: realm.objects(Tweet.self).sorted(byKeyPath: "date", ascending: false))
        
        restoreFromUserDefaults()
    }
    
    /// Check if user was persisted from a previous session
    func restoreFromUserDefaults() {
        guard let email = UserDefaults.standard.string(forKey: Cache.userDefaultsKey) else { return }
        let realm = try! Realm()
        guard let user = realm.object(ofType: User.self, forPrimaryKey: email) else { return }
        setCurrentUser(user)
    }
    
    /// Set and persist a new current `User`
    ///
    /// - Parameter user: The new current `User`
    func setCurrentUser(_ user: User) {
        addUser(user)
        UserDefaults.standard.set(user.email, forKey: Cache.userDefaultsKey)
        _user.value = user
    }
    
    /// Add a `User` to the cache using keychain to store password
    ///
    /// - Parameter user: The `User` to add
    func addUser(_ user: User) {
        guard getUser(withEmail: user.email) == nil else { return }
        
        keychain.set(user.password, forKey: user.email)
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(user)
        }
    }
    
    /// Fetch an existing user from the cache and populate the password property from the keychain
    ///
    /// - Parameter email: The email address of the user to fetch
    /// - Returns: An optional `User` instance representing the existing user in the cache
    func getUser(withEmail email: String) -> User? {
        let realm = try! Realm()
        let user = realm.object(ofType: User.self, forPrimaryKey: email)
        user?.password = keychain.get(email)
        return user
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
        keychain.clear()
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
}
