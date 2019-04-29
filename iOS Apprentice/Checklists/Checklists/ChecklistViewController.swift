//
//  ViewController.swift
//  Checklists
//
//  Created by Maksim Nosov on 22/04/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, AddItemViewControllerDelegate {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true) // удалить из стека NavigationController верхний View Controller и обновить экран. Мы передали команду делегату AddItemViewControllerDelegate закрыть экран AddItemViewController.
        // Тем самым мы выполняем метод из другого класса, делегатом которого являемся
        
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = items.count // Индекс новой строки в массиве items (так как массивы считаются с 0, следующий элемент будет на 1 позицию больше из-за метода count, который считает количество элементов с 1. Удачное применение!
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0) // IndexPath объект который указывает на новую строку используя локальную переменную newRowIndex
        let indexPaths = [indexPath] // временный массив содержащий только один indexPath
        tableView.insertRows(at: indexPaths, with: .automatic) // Сообщаем tableView добавить новые ячейки из массива indexPaths

        navigationController?.popViewController(animated: true)
        saveCheckListItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        saveCheckListItems()
    }
    
    
    var items = [ChecklistItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never // Отключить большой заголовок для этого контроллера
        
        // Загрузка данных из plist файла
        loadChecklistItems()
    }
    
    // Путь к директории с файлом
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Полный путь к файлу, включая имя файла
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklist.plist")
    }
    
    // Сохранение данных в plist
    func saveCheckListItems() {
        let encoder = PropertyListEncoder() // Объект который кодирует в тип данных для сохранения как plist
        
        do {
            let data = try encoder.encode(items) // конвертирует массив ITEMS в блок двоичных данных
            
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic) // сохраняет данные в файл по адресу dataFilePath()
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    // Загрузка данных из plist
    func loadChecklistItems() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) { // возвратить nil если ошибка получения данных (try?)
            let decoder = PropertyListDecoder() // объект для декодирования из бинарных файлов.
            
            do {
                items = try decoder.decode([ChecklistItem].self, from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
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
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }

        
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row) // Удаление строки из массива
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic) // Удаление ячейки из tableView
        saveCheckListItems()
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        
        let label = cell.viewWithTag(1001) as! UILabel
        
        label.text = item.checked ? "√" : ""
        
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
        saveCheckListItems()
    }
    
    
}

