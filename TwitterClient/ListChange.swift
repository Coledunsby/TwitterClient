//
//  ListChange.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-15.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxDataSources

struct ListChange<T: IdentifiableType & Equatable> {
    
    enum Operation {
        
        case insert
        case update
        case delete
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
        case .delete:
            section.items.remove(at: index)
        }
    }
}
