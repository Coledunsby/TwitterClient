//
//  ListChange.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-15.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxDataSources

struct Section<T: IdentifiableType & Equatable> {
    
    fileprivate var uuid = UUID()
    var items: [T]
    var header: String?
    var footer: String?
    
    init(items: [T]? = [], header: String? = nil, footer: String? = nil) {
        self.items = items ?? []
        self.header = header
        self.footer = footer
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

struct ListChange<T> {
    
    enum Operation {
        
        case insert
        case update
        case remove
    }
    
    var operation: Operation
    var object: T
    
    init(_ operation: Operation, _ object: T) {
        self.object = object
        self.operation = operation
    }
    
    func performOperation(on section: inout Section<T>) {
        let index = section.items.index(where: { $0.identity == object.identity }) ?? section.items.count
        switch operation {
        case .insert:
            section.items.insert(object, at: index)
        case .update:
            section.items[index] = object
        case .remove:
            section.items.remove(at: index)
        }
    }
}
