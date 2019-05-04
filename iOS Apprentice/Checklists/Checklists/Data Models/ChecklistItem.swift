//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Maksim Nosov on 23/04/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation
import UserNotifications

// Наследуем от NSObject, чтобы соответствовать протоколу Equiatable, для использования firstIndex(of:) в ChecklistViewController в методе делегата itemDetailViewController(:didFinishEditing)
// Codable - поддержка протокола позволяющий конвертировать себя В и ИЗ внешних данных.
class ChecklistItem: NSObject, Codable {
    var text = ""
    var checked = false
    
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1
    
    override init() {
        super.init()
        itemID = DataModel.nextChecklistItemID() // Создание уникального ID для нотификаций
    }
    
    func toggleChecked() {
        checked = !checked
    }
    
    func scheduleNotification() {
        if shouldRemind && dueDate > Date() {
            
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
            print("Scheduled: \(request) for itemID: \(itemID)")
        }
    }
}
