//
//  UIAlertController+Extensions.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-22.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    /// Returns a `UIAlertController` formatted to display an error
    ///
    /// - Parameter error: The error to alert the user of
    /// - Returns: An error alert
    static func error(_ error: Error) -> UIAlertController {
        let alertController = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alertController
    }
}
