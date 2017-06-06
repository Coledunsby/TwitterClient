//
//  Extensions.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-05.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxSwift
import RxSwiftExt

extension ObservableType where E: EventConvertible {
    
    func skipCompleted() -> Observable<E> {
        return filter { e in
            switch e.event {
            case .completed:
                return false
            default:
                return true
            }
        }
    }
}

extension ObservableType {
    
    func asCompletable() -> Completable {
        return asObservable().mapTo(()).flatMapLatest({ Observable<Never>.empty() }).asCompletable()
    }
    
    func ignoreCompleted() -> Observable<E> {
        return materialize().skipCompleted().dematerialize()
    }
}
