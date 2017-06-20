//
//  RxSwift+Extensions.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-19.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift

extension ObservableType {
    
    func prevAndNext() -> Observable<(E?, E)> {
        return self
            .scan((.none, .none)) { acc, next in
                return (acc.1, next)
            }
            .map { prev, next in
                return (prev, next!)
            }
    }
    
    public func asOptional() -> Observable<E?> {
        return self.map { $0 as E? }
    }
}

extension PrimitiveSequence {
    
    /// Returns an observable sequence containing as many elements as its input but all of them are the constant provided as a parameter
    ///
    /// - Parameter value: A constant that each element of the input sequence is being replaced with
    /// - Returns: An observable sequence containing the values `value` provided as a parameter
    public func mapTo<R>(_ value: R) -> Observable<R> {
        return asObservable().mapTo(value)
    }
}

extension PrimitiveSequence where TraitType == CompletableTrait {
    
    public func asSingle() -> Single<Void> {
        return self
            .mapTo(())
            .concat(Observable.just(()))
            .asSingle()
    }
}
