//
//  RxSwift+Extensions.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-19.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift
import SwiftRandom

extension PrimitiveSequence {
    
    /// Returns an observable sequence containing as many elements as its input but all of them are the constant provided as a parameter
    ///
    /// - Parameter value: A constant that each element of the input sequence is being replaced with
    /// - Returns: An observable sequence containing the values `value` provided as a parameter
    public func mapTo<R>(_ value: R) -> Observable<R> {
        return self
            .asObservable()
            .mapTo(value)
    }
    
    /// Simulate a random network delay
    ///
    /// - Returns: the source Observable shifted in time by the random network delay
    func simulateNetworkDelay() -> PrimitiveSequence<Trait, Element> {
        return self.delay(TimeInterval.random(0.1, 1.0), scheduler: MainScheduler.instance)
    }
}

extension PrimitiveSequence where TraitType == CompletableTrait {
    
    /// Converting a `Completable` to an `Observable` then to a `Single` does not work
    /// because a `Completable` does not emit any elements by design. This function 
    /// converts a `Completable` to a `Single<Void>` by concatenating an empty void observable
    ///
    /// - Returns: A `Single<Void>` representation of the `Completable`
    public func asSingle() -> Single<Void> {
        return self
            .mapTo(())
            .concat(Observable.just(()))
            .asSingle()
    }
}
