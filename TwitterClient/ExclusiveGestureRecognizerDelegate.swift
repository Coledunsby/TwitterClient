//
//  ExclusiveGestureRecognizerDelegate.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-07.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import RxGesture

final class ExclusiveGestureRecognizerDelegate: NSObject, GestureRecognizerDelegate {
    
    static let shared = ExclusiveGestureRecognizerDelegate()
    
    func gestureRecognizer(_ gestureRecognizer: GestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: GestureRecognizer) -> Bool {
        return false
    }
}
