//
//  Tweet.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-05.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RealmSwift

final class Tweet: Object {
    
    dynamic var id = UUID().uuidString
    dynamic var user: User!
    dynamic var message = ""
    dynamic var date = Date()
    
    public override static func primaryKey() -> String? {
        return "id"
    }
}
