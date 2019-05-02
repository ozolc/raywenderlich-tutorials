//
//  AppDelegate.swift
//  Checklists
//
//  Created by Maksim Nosov on 22/04/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let dataModel = DataModel() // Объект модели данных

    // MARK: - Helper Methods
    func saveData() {
        dataModel.saveChecklists()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let navigationController = window!.rootViewController as! UINavigationController
        let controller = navigationController.viewControllers[0] as! AllListsViewController
        controller.dataModel = dataModel // Присвоили ссылку на созданный объект модели данных при запуске приложения.
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        saveData()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveData()
    }


}

