//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Maksim Nosov on 23/04/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never // Не отображать большой заголовок в NavigationItem
    }

    // MARK: - Actions
    @IBAction func cancel() {
        navigationController?.popViewController(animated: true) // удалить из стека Navigation стека верхний View Controller и обновить экран.
    }
    
    @IBAction func done() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source
}
