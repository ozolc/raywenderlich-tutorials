//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by Maksim Nosov on 02/05/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate: class {
    // Метод делегата при выборе иконки
    func iconPicker(_ controller: IconPickerViewController,
                    didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
    
    let cellId = "IconCell"
    
    weak var delegate: IconPickerViewControllerDelegate?
    
    let icons = [ "No Icon", "Appointments", "Birthdays", "Chores", "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips" ]
    
    // MARK:- Table View Delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        
        let iconName = icons[indexPath.row]
        cell.textLabel!.text = iconName
        cell.imageView!.image = UIImage(named: iconName)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            let iconName = icons[indexPath.row]
            delegate.iconPicker(self, didPick: iconName)
        }
    }
}
