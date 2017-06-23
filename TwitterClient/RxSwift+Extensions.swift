//
//  RxSwift+Extensions.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-19.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxCocoa
import RxSwift
import RxSwiftExt
import SwiftRandom

extension PrimitiveSequence {
    
    /// Returns an observable sequence containing as many elements as its input but all of them are the constant provided as a parameter
    ///
    /// - Parameter value: A constant that each element of the input sequence is being replaced with
    /// - Returns: An observable sequence containing the values `value` provided as a parameter
    func mapTo<R>(_ value: R) -> PrimitiveSequence<Trait, R> {
        return self.map { _ in value }
    }
    
    /// Simulate a random network delay
    /// NOTE: only applies to non test environment (delay was messing up tests)
    ///
    /// - Returns: the source Observable shifted in time by the random network delay
    func simulateNetworkDelay() -> PrimitiveSequence<Trait, Element> {
        guard ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil else { return self }
        return self.delay(TimeInterval.random(0.1, 1.0), scheduler: MainScheduler.instance)
    }
}

extension PrimitiveSequence where TraitType == CompletableTrait {
    
    /// Converting a `Completable` to an `Observable` then to a `Single` does not work
    /// because a `Completable` does not emit any elements by design. This function 
    /// converts a `Completable` to a `Single<Void>` by concatenating an empty void observable
    ///
    /// - Returns: A `Single<Void>` representation of the `Completable`
    func asSingle() -> Single<Void> {
        return self
            .asObservable()
            .mapTo(())
            .concat(Observable.just(()))
            .asSingle()
    }
}
