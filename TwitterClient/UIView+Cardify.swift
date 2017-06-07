//
//  UIView+Cardify.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-06.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import UIKit

extension UIView {
    
    func cardify() {
        layer.masksToBounds = false
        layer.cornerRadius = 2.0
        layer.shadowColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1).cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowRadius = 0.6
        layer.shadowOpacity = 0.5
    }
}
