//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Maksim Nosov on 29/04/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {

    func listDetailViewControllerDidCancel(_ sender: ListDetailViewController)
    func listDetailViewControllerDidCancel(_ sender: ListDetailViewController, didFinishAdding checklist: Checklist)
    func listDetailViewControllerDidCancel(_ sender: ListDetailViewController, didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController, ListDetailViewControllerDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checklistToEdit: Checklist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(<#T##sender: ListDetailViewController##ListDetailViewController#>)
    }
    
    @IBAction func done() {
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            delegate?.listDetailViewControllerDidCancel(self, didFinishEditing: checklist)
        } else {
            let checklist = Checklist(name: textField.text!)
            delegate?.listDetailViewControllerDidCancel(self, didFinishAdding: checklist)
        }
    }
    
    func listDetailViewControllerDidCancel(_ sender: ListDetailViewController) {
        <#code#>
    }
    
    func listDetailViewControllerDidCancel(_ sender: ListDetailViewController, didFinishAdding checklist: Checklist) {
        <#code#>
    }
    
    func listDetailViewControllerDidCancel(_ sender: ListDetailViewController, didFinishEditing checklist: Checklist) {
        <#code#>
    }
    
    
}
