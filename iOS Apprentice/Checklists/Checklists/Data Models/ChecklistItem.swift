//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Maksim Nosov on 23/04/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation
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
}
