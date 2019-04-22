//
//  ViewController.swift
//  Checklists
//
//  Created by Maksim Nosov on 22/04/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let label = cell.viewWithTag(1000) as! UILabel
        
        switch indexPath.row {
        case let x where x % 5 == 0: label.text = "Walk the dog"
        case let x where x % 5 == 1: label.text = "Brush my teeth"
        case let x where x % 5 == 2: label.text = "Learn iOS development"
        case let x where x % 5 == 3: label.text = "Soccer practice"
        case let x where x % 5 == 4: label.text = "Eat ice cream"
        default: break
        }
        
        return cell
    }
}

