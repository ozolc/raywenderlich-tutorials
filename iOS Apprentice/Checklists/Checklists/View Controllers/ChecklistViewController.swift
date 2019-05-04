//
//  ViewController.swift
//  Checklists
//
//  Created by Maksim Nosov on 22/04/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true) // удалить из стека NavigationController верхний View Controller и обновить экран. Мы передали команду делегату AddItemViewControllerDelegate закрыть экран AddItemViewController.
        // Тем самым мы выполняем метод из другого класса, делегатом которого являемся
        
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count // Индекс новой строки в массиве items (так как массивы считаются с 0, следующий элемент будет на 1 позицию больше из-за метода count, который считает количество элементов с 1. Удачное применение!
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0) // IndexPath объект который указывает на новую строку используя локальную переменную newRowIndex
        let indexPaths = [indexPath] // временный массив содержащий только один indexPath
        tableView.insertRows(at: indexPaths, with: .automatic) // Сообщаем tableView добавить новые ячейки из массива indexPaths

        navigationController?.popViewController(animated: true)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    var checklist: Checklist! // для передачи данных, мы устанавливаем его псевдо nil используя force unwrapping
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never // Отключить большой заголовок для этого контроллера
        
        title = checklist.name // Установить заголовок из списка TO-DO
        
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" { // проверяем идентификатор segue
            let controller = segue.destination as! ItemDetailViewController // создаем ссылку на destination сегвея и force downcast его как тип AddItemViewController, т.к. destination имеет тип ViewController. Downcast не выбросит nill, т.к. AddItemViewController подкласс UIViewContoller.
            controller.delegate = self // Говорим, что делегат класса AddItemViewController будет класс ChecklistViewController (т.е. SELF - этот класс)
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            
            // получим IndexPath нажатой ячейки, чтобы передать индекс массива с текстом для передачи в другой контроллер для изменения.
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }

        
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row) // Удаление строки из массива
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic) // Удаление ячейки из tableView
        
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        
        let label = cell.viewWithTag(1001) as! UILabel
        
        label.text = item.checked ? "√" : ""
        
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        
        let label = cell.viewWithTag(1000) as! UILabel
//        label.text = item.text
        label.text = "\(item.itemID): \(item.text)"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = checklist.items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

