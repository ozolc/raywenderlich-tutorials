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
    
    // MARK: - Properties
    var splitVC: UISplitViewController {
        return window!.rootViewController as! UISplitViewController
    }
    
    var searchVC: SearchViewController {
        return splitVC.viewControllers.first as! SearchViewController
    }
    
    var detailNavController: UINavigationController {
        return splitVC.viewControllers.last as! UINavigationController
    }
    
    var detailVC: DetailViewController {
        return detailNavController.topViewController as! DetailViewController
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        detailVC.navigationItem.leftBarButtonItem = splitVC.displayModeButtonItem
        customizeAppearance()
        
        return true
    }
    
    // MARK: - Helper Methods
    func customizeAppearance() {
        let barTintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 1)
        UISearchBar.appearance().barTintColor = barTintColor
	    }


}

