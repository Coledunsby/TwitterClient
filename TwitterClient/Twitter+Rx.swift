//
//  Twitter+Rx.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-08.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import TwitterKit
import RxSwift

extension Reactive where Base: Twitter {
    
    func logIn() -> Single<TWTRSession> {
        return Single.create { single in
            self.base.logIn { session, error in
                if let session = session {
                    single(.success(session))
                } else {
                    single(.error(error!))
                }
            }
            return Disposables.create()
        }
    }
    
    func logIn(with viewController: UIViewController?) -> Single<TWTRSession> {
        return Single.create { single in
            self.base.logIn(with: viewController) { session, error in
                if let session = session {
                    single(.success(session))
                } else {
                    single(.error(error!))
                }
            }
            return Disposables.create()
        }
    }
}
