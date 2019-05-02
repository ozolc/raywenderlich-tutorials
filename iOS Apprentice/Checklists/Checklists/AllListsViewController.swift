//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Maksim Nosov on 29/04/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {
    // MARK:- List Detail View Controller Delegates
    
    func listDetailViewControllerDidCancel(_ sender: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewControllerDidCancel(_ sender: ListDetailViewController, didFinishAdding checklist: Checklist) {
        print("delegate cancel")
        let newRoundIndex = dataModel.lists.count
        dataModel.lists.append(checklist)
        
        let indexPath = IndexPath(row: newRoundIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewControllerDidCancel(_ sender: ListDetailViewController, didFinishEditing checklist: Checklist) {
        if let index = dataModel.lists.firstIndex(of: checklist) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel!.text = checklist.name
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
//    var lists = [Checklist]() // массив с элементами чеклистов.
    
    let cellIdentifier = "ChecklistCell"
    var dataModel: DataModel! // ! - необходимо, потому что dataModel будет временно nil, когда приложение стартует
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier) // Регистрация идентификатора ячейки cellIdentifier, чтобы tableView знала, какую ячейку следует использовать для создания при вызове dequeue когда укажут этот идентификатор. В данном случае будет зарегистрирована стандартная ячейка UITableViewCell
        
        navigationController?.navigationBar.prefersLargeTitles = true // Установить большой заголовок для всех AllListsViewController
        
//        var list = Checklist(name: "Birthdays")
//        lists.append(list)
//
//        list = Checklist(name: "Groceries")
//        lists.append(list)
//
//        list = Checklist(name: "Cool Apps")
//        lists.append(list)
//
//        list = Checklist(name: "To Do")
//        lists.append(list)
//
//        for list in lists {
//            let item = ChecklistItem()
//            item.text = "Item for \(list.name)"
//            list.items.append(item)
//        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist) // Выполним отправку в ChecklistViewController элемент массива checklist. Настройка производится в prepare-for-segue
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as? Checklist // Подготавливаем к передаче checklist (элемент из массива lists[Checklist]
        } else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        navigationController?.pushViewController(controller, animated: true)
    }

}
