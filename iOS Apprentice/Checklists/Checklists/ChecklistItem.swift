//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Maksim Nosov on 23/04/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation
// Наследуем от NSObject, что соответствовать протоколу Equiatable, для использования firstIndex(of:) в ChecklistViewController в методе делегата itemDetailViewController(:didFinishEditing)
class ChecklistItem: NSObject {
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
}
