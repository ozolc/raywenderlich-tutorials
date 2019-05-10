//
//  AppDelegate.swift
//  StoreSearch
//
//  Created by Maksim Nosov on 09/05/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        customizeAppearance()
        
        return true
    }
    
    // MARK: - Helper Methods
    func customizeAppearance() {
        let barTintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 1)
        UISearchBar.appearance().barTintColor = barTintColor
	    }


}

