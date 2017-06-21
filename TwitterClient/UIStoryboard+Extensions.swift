//
//  UIStoryboard+Extensions.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-19.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    static var login: UIStoryboard {
        return UIStoryboard(name: "Login", bundle: nil)
    }
    
    static var tweets: UIStoryboard {
        return UIStoryboard(name: "Tweets", bundle: nil)
    }
    
    static var compose: UIStoryboard {
        return UIStoryboard(name: "Compose", bundle: nil)
    }
    
    /// Instantiates and returns the initial view controller of a specific 
    /// type in the view controller graph
    ///
    /// - Parameter type: The type of the initial view controller
    /// - Returns: The initial view controller
    func instantiateInitialViewController<C: UIViewController>(ofType type: C.Type) -> C {
        return instantiateInitialViewController() as! C
    }
}
