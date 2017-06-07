//
//  User.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-06.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RealmSwift

final class User: Object {
    
    static var current: User? {
        guard let email = UserDefaults.standard.string(forKey: "user_email") else { return nil }
        guard let realm = try? Realm() else { return nil }
        return realm.object(ofType: User.self, forPrimaryKey: email)
    }
    
    dynamic var email: String!
    
    private let _tweets = LinkingObjects(fromType: Tweet.self, property: "user")
    var tweets: [Tweet] {
        return Array(_tweets)
    }
    
    public override static func primaryKey() -> String? {
        return "email"
    }
}
