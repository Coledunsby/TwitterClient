//
//  CardButton.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-06.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import UIKit

final class CardButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cardify()
    }
}
