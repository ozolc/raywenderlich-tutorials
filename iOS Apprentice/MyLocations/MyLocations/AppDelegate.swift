//
//  AppDelegate.swift
//  MyLocations
//
//  Created by Maksim Nosov on 05/05/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Could load data store: \(error)")
            }
        }
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = persistentContainer.viewContext

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        customizeAppearance()
        
        let tabController = window!.rootViewController as! UITabBarController
        
        // Dependency injection для managedObjectContext
        // Первый Tab (Current Location)- передача managedObjectContext
        if let tabViewControllers = tabController.viewControllers {
            var navController = tabViewControllers[0] as! UINavigationController
            let controller1 = navController.viewControllers.first as! CurrentLocationViewController
            controller1.managedObjectContext = managedObjectContext
        
        // Второй Tab (Locations) - передача managedObjectContext
            navController = tabViewControllers[1] as! UINavigationController
            let controller2 = navController.viewControllers.first as! LocationsViewController
            controller2.managedObjectContext = managedObjectContext
        
        // Третий Tab (Locations) - передача managedObjectContext
            navController = tabViewControllers[2] as! UINavigationController
            let controller3 = navController.viewControllers.first as! MapViewController
            controller3.managedObjectContext = managedObjectContext
        }
        
        print(applicationDocumentsDirectory)
        listenForFatalCoreDataNotifications()
        return true
    }
    
    // MARK:- Helper methods
    func listenForFatalCoreDataNotifications() {
        NotificationCenter.default.addObserver(forName: CoreDataSaveFailedNotification,
                                               object: nil,
                                               queue: OperationQueue.main) { notification in
                                                let message = """
                                                There was a fatal error in the app and it cannot continue.

                                                Press OK to terminate the app. Sorry for the inconvenience.
                                                """
        let alert = UIAlertController(title: "Internal Error", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            let exception = NSException(name: NSExceptionName.internalInconsistencyException, reason: "Fatal Core Data error", userInfo: nil)
            
            exception.raise()
        })
        alert.addAction(action)
                                                
        let tabController = self.window!.rootViewController!
        tabController.present(alert, animated: true, completion: nil)
        }
    }
    
    func customizeAppearance() {
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        UITabBar.appearance().barTintColor = UIColor.black
        
        let tintColor = UIColor(red: 255/255.0, green: 238/255.0, blue: 136/255.0, alpha: 1.0)
        UITabBar.appearance().tintColor = tintColor
    }


}

