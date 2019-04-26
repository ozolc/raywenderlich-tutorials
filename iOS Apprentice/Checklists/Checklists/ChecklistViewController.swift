//
//  ViewController.swift
//  Checklists
//
//  Created by Maksim Nosov on 22/04/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, AddItemViewControllerDelegate {
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        navigationController?.popViewController(animated: true) // удалить из стека NavigationController верхний View Controller и обновить экран. Мы передали команду делегату AddItemViewControllerDelegate закрыть экран AddItemViewController.
        // Тем самым мы выполняем метод из другого класса, делегатом которого являемся
        
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
    var items = [ChecklistItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true // Установить большой заголовок для всех ViewController
        
        let item1 = ChecklistItem()
        item1.text = "Walk the dog"
        items.append(item1)
        
        let item2 = ChecklistItem()
        item2.text = "Brush my teeth"
        item2.checked = true
        items.append(item2)
        
        let item3 = ChecklistItem()
        item3.text = "Learn iOS development"
        item3.checked = true
        items.append(item3)
        
        let item4 = ChecklistItem()
        item4.text = "Soccer practice"
        items.append(item4)
        
        let item5 = ChecklistItem()
        item5.text = "Eat ice cream"
        items.append(item5)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" { // проверяем идентификатор segue
            let controller = segue.destination as! AddItemViewController // создаем ссылку на destination сегвея и force downcast его как тип AddItemViewController, т.к. destination имеет тип ViewController. Downcast не выбросит nill, т.к. AddItemViewController подкласс UIViewContoller.
            controller.delegate = self // Говорим, что делегат класса AddItemViewController будет класс ChecklistViewController (т.е. SELF - этот класс)
        }
    }

    // MARK: - Action
    @IBAction func addItem() {
        let newRowIndex = items.count // Индекс новой строки в массиве items (так как массивы считаются с 0, следующий элемент будет на 1 позицию больше из-за метода count, который считает количество элементов с 1. Удачное применение!
        
        let item = ChecklistItem()
        item.text = "I am a new row"
        item.checked = true
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0) // IndexPath объект который указывает на новую строку используя локальную переменную newRowIndex
        let indexPaths = [indexPath] // временный массив содержащий только один indexPath
        tableView.insertRows(at: indexPaths, with: .automatic) // Сообщаем tableView добавить новые ячейки из массива indexPaths
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row) // Удаление строки из массива
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic) // Удаление ячейки из tableView
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        
        cell.accessoryType = item.checked ? .checkmark : .none
        
    }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

