//
//  User.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-06.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RealmSwift
import RxSwift

final class User: Object {
    
    dynamic var email: String!
    dynamic var password: String!
    
    let tweets = LinkingObjects(fromType: Tweet.self, property: "user")
    
    public override static func primaryKey() -> String? {
        return "email"
    }
}

extension User {
    
    func tweet(message: String) {
        let tweet = Tweet()
        tweet.id = UUID().uuidString
        tweet.user = self
        tweet.message = message
        tweet.date = Date()
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(tweet)
        }
    }
}

extension User {
    
    static var current: User? {
//        guard let email = UserDefaults.standard.string(forKey: userDefaultsKey) else { return nil }
        let realm = try! Realm()
        return realm.object(ofType: User.self, forPrimaryKey: "")
    }
}
