//
//  Section.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-15.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxDataSources

struct Section<T: IdentifiableType & Equatable> {
    
    fileprivate var uuid = UUID()
    
    var items: [T]
    
    init(items: [T]? = []) {
        self.items = items ?? []
    }
}

extension Section: AnimatableSectionModelType {
    
    typealias Item = T
    
    var identity: UUID {
        return uuid
    }
    
    init(original: Section, items: [Item]) {
        self = original
        self.items = items
    }
}
