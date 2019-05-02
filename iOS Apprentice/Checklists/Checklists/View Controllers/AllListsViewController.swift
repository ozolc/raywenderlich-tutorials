//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Maksim Nosov on 29/04/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    // MARK:- Navigation Controller Delegates
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // Этот метод вызывается когда Navigation Controller отображает новое окно.
        // Если кнопка Back была нажата и новый View Controller это AllListsViewController. Устанавливаем значение (-1), указывающее, что не выбран ни один checklist
        
        // == - проверка, что две переменные имеют одинаковое значение
        // === - проверка, что две переменные ссылаются на один и тот же объект
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
    // MARK:- List Detail View Controller Delegates
    
    func listDetailViewControllerDidCancel(_ sender: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewControllerDidCancel(_ sender: ListDetailViewController, didFinishAdding checklist: Checklist) {
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
    
    let cellIdentifier = "ChecklistCell"
    var dataModel: DataModel! // ! - необходимо, потому что dataModel будет временно nil, когда приложение стартует
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier) // Регистрация идентификатора ячейки cellIdentifier, чтобы tableView знала, какую ячейку следует использовать для создания при вызове dequeue когда укажут этот идентификатор. В данном случае будет зарегистрирована стандартная ячейка UITableViewCell
        
        navigationController?.navigationBar.prefersLargeTitles = true // Установить большой заголовок для всех AllListsViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // Этот метод автоматически вызывается UIKit когда view controllers становятся видимыми.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        navigationController?.delegate = self // подписываемся делегатом navigation controller
        
        let index = dataModel.indexOfSelectedChecklist // выбранный элемент (computed property считывает значение из UserDefaults)
        
        // Если в прошлый раз пользователь был не в главном окне. Также проверяем, что данные в модели синхронизированы и мы не отобразим segue с данными вне диапазона массива lists[].
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        
        if let c = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = c
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        
        // Настройка ячейки
        let checklist = dataModel.lists[indexPath.row] // Получение объекта из модели данных.
        let count = checklist.countUncheckedItems()
        
        cell.accessoryType = .detailDisclosureButton
        if let label = cell.textLabel {
            label.text = checklist.name
        }
        
        if let label = cell.detailTextLabel {
            if checklist.items.count == 0 {
                label.text = "(No Items)"
            } else {
                label.text = count == 0 ? "All Done" : "\(count) Remaining"
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Сохранение выбранной ячейки в UserDefaults через computed property
        dataModel.indexOfSelectedChecklist = indexPath.row
        
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
