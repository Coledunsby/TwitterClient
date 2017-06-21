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

extension ObservableType {
    
    /// Converts the type of the elements in observable sequence to optionals
    ///
    /// - Returns: An observable sequence of optional elements
    func asOptional() -> Observable<E?> {
        return self.map { $0 as E? }
    }
}

extension PrimitiveSequence {
    
    /// Returns an observable sequence containing as many elements as its input but all of them are the constant provided as a parameter
    ///
    /// - Parameter value: A constant that each element of the input sequence is being replaced with
    /// - Returns: An observable sequence containing the values `value` provided as a parameter
    func mapTo<R>(_ value: R) -> PrimitiveSequence<Trait, R> {
        return self.map { _ in value }
    }
    
    /// Converts the type of the elements in observable sequence to optionals
    ///
    /// - Returns: An observable sequence of optional elements
    func asOptional() -> PrimitiveSequence<Trait, E?> {
        return self.map { $0 as E? }
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
    func asSingle() -> Single<Void> {
        return self
            .asObservable()
            .mapTo(())
            .concat(Observable.just(()))
            .asSingle()
    }
}

extension SharedSequenceConvertibleType {
    
    /// Returns an observable sequence containing as many elements as its input but all of them are the constant provided as a parameter
    ///
    /// - Parameter value: A constant that each element of the input sequence is being replaced with
    /// - Returns: An observable sequence containing the values `value` provided as a parameter
    func mapTo<R>(_ value: R) -> SharedSequence<SharingStrategy, R> {
        return self.map { _ in value }
    }
}

extension SharedSequenceConvertibleType where E: Optionable {
    
    /// Takes a sequence of optional elements and returns a sequence of non-optional elements, filtering out any nil values
    ///
    /// - Returns: An observable sequence of non-optional elements
    public func unwrap() -> SharedSequence<SharingStrategy, E.WrappedType> {
        return self
            .filter { !$0.isEmpty() }
            .map { $0.unwrap() }
    }
}
