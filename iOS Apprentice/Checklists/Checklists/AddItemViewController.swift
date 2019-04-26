//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Maksim Nosov on 23/04/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit
// class - этот протокол могу реализовывать только классы. для того чтобы иметь weak ссылку на делегат
protocol AddItemViewControllerDelegate: class {
    func addItemViewControllerDidCancel(_ controller: AddItemViewController)
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem)
}

class AddItemViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: AddItemViewControllerDelegate? // ссылка на класс, который подписывается под протокол AddItemViewControllerDelegate
    
    var itemToEdit: ChecklistItem? // объект ChecklistItem, переданный из ChecklistViewController для изменения. nil - так как используются две segue для изменения(не nil) и для добавления(nil) нового элемента в таблицу
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never // Не отображать большой заголовок в NavigationItem
        
        // если передано значение из ячейки для изменения, то меняем заголовок Controller и подставляем значение в TextField
        if let item = itemToEdit {
            title = "Edite Item"
            textField.text = item.text
        }
    }

    // MARK: - Actions
    @IBAction func cancel() {
        delegate?.addItemViewControllerDidCancel(self) // Когда нажимает кнопку Cancel - мы отправляем сообщение назад делегату
    }
    
    @IBAction func done() {
        let item = ChecklistItem()
        item.text = textField.text!
        
        delegate?.addItemViewController(self, didFinishAdding: item) // передаем делегату созданный объект класса ChecklistItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    // MARK: - Text Field Delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        
        doneBarButton.isEnabled = !newText.isEmpty // Если TextField пустая - кнопка Done неактивна
        return true
    }
    
    // Метод если мы удаляем через Clear button в текстовом поле (быстрая очистка)
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}
