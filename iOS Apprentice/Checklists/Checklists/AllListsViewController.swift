//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Maksim Nosov on 29/04/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController {
    
    let cellIdentifier = "ChecklistCell"
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier) // Регистрация идентификатора ячейки cellIdentifier, чтобы tableView знала, какую ячейку следует использовать для создания при вызове dequeue когда укажут этот идентификатор. В данном случае будет зарегистрирована стандартная ячейка UITableViewCell
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        cell.textLabel!.text = "List \(indexPath.row)"

        return cell
    }
    
}
