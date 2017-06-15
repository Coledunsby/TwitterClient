//
//  RealmObject.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-15.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RealmSwift
import RxDataSources

class RealmObject: Object, IdentifiableType {
    
    typealias Identity = String
    
    var identity: String {
        return "\(self.value(forKey: type(of: self).primaryKey()!)!)"
    }
}
