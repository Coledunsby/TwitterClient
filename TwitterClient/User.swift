//
//  User.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-06.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RealmSwift

final class User: RealmObject {
    
    dynamic var email: String!
    dynamic var password: String!
    
    var handle: String! {
        return email.components(separatedBy: "@").first
    }
    
    let tweets = LinkingObjects(fromType: Tweet.self, property: "user")
    
    public override static func primaryKey() -> String? {
        return "email"
    }
}

extension User {
    
    static var current: User? {
//        guard let email = UserDefaults.standard.string(forKey: userDefaultsKey) else { return nil }
        let realm = try! Realm()
        return realm.object(ofType: User.self, forPrimaryKey: "")
    }
}
