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
    
    func ignoreCompleted() -> Observable<E> {
        return self.materialize().skipCompleted().dematerialize()
    }
    
    func thread<O: ObservableConvertibleType>(_ selector: @escaping (E) throws -> O) -> Observable<O.E> {
        return self.flatMap(selector).ignoreCompleted()
    }
    
    func threadWithIndex<O: ObservableConvertibleType>(_ selector: @escaping (E, Int) throws -> O) -> Observable<O.E> {
        return self.flatMapWithIndex(selector).ignoreCompleted()
    }
    
    func threadFirst<O: ObservableConvertibleType>(_ selector: @escaping (E) throws -> O) -> Observable<O.E> {
        return self.flatMapFirst(selector).ignoreCompleted()
    }
    
    func threadLatest<O: ObservableConvertibleType>(_ selector: @escaping (E) throws -> O) -> Observable<O.E> {
        return self.flatMapLatest(selector).ignoreCompleted()
    }
}

extension ObservableType where E: EventConvertible {
    
    func skipCompleted() -> Observable<E> {
        return self.filter { e in
            switch e.event {
            case .completed:
                return false
            default:
                return true
            }
        }
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
    
    /// Simulate a random network delay
    ///
    /// - Returns: the source Observable shifted in time by the random network delay
    func simulateNetworkDelay() -> PrimitiveSequence<Trait, Element> {
        return self.delay(TimeInterval.random(0.1, 0.2), scheduler: MainScheduler.instance)
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
