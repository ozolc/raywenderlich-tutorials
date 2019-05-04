//
//  AppDelegate.swift
//  Checklists
//
//  Created by Maksim Nosov on 22/04/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
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
        
        // Разрешение Notifocation
        let center = UNUserNotificationCenter.current()
        
//        center.requestAuthorization(options: [.alert, .sound]) {
//            granted, error in
//            if granted {
//                print("We have permission")
//            } else {
//                print("Permission denied")
//            }
//        }
//
//        let content = UNMutableNotificationContent()
//        content.title = "Hello!"
//        content.body = "I am a local notification"
//        content.sound = UNNotificationSound.default
        
        // Создание контента для Notification
        // iOS отображает notification, только когда приложение не активно
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        let request = UNNotificationRequest(identifier: "MyNotification", content: content, trigger: trigger)
//        center.add(request)
        
        center.delegate = self
        
        return true
    }
    
    // MARK:- User Notification Delegates
    
    // Метод будет вызван, когда локальная нотификация будет отправлена и приложение запущено.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Received local notification \(notification)")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        saveData()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveData()
    }


}

