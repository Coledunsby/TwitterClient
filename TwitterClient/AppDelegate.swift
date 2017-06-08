//
//  AppDelegate.swift
//  TwitterClient
//
//  Created by Cole Dunsby on 2017-06-05.
//  Copyright © 2017 Cole Dunsby. All rights reserved.
//

import UIKit
import TwitterKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Twitter.sharedInstance().start(withConsumerKey: "UwB54PN3K9elYdBOauuX0RQHK", consumerSecret: "cMbjDGGtDSY4mlUorSvd5NAANi9BsWfpXGIfDARom3E5ug6m1y")
        customizeAppearance()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return Twitter.sharedInstance().application(app, open: url, options: options)
    }
    
    private func customizeAppearance() {
        let primaryColor = #colorLiteral(red: 0.1137254902, green: 0.631372549, blue: 0.9490196078, alpha: 1)
        let secondaryColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "AvenirNext-DemiBold", size: 18)!,
            NSForegroundColorAttributeName: secondaryColor
        ]
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = secondaryColor
        UINavigationBar.appearance().barTintColor = primaryColor
        
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().tintColor = secondaryColor
        UITabBar.appearance().barTintColor = primaryColor
        
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSFontAttributeName: UIFont(name: "AvenirNext-DemiBold", size: 16)!,
            NSForegroundColorAttributeName: secondaryColor
        ], for: .normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([
            NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 9)!,
            NSForegroundColorAttributeName: secondaryColor
        ], for: .normal)
    }
}

