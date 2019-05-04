//
//  DataModel.swift
//  Checklists
//
//  Created by Maksim Nosov on 02/05/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

// Модель данных объектов с массивом Checklist объектов. Она знает как загружать и сохранять checklists и их элементы
class DataModel {
    
    var lists = [Checklist]()
    
    let userDefaults = UserDefaults.standard
    let checklistIndexUD = "ChecklistIndex"
    let firstTimeUD = "FirstTime" // Первый раз запущено приложение?
    
    
    init() {
        loadChecklists() // Загрузка данных из plist
        registerDefaults() // Регистрируем значение по-умолчанию
        handleFirstTime() // Проверка запуск приложения в первый раз
    }
    
    // Сортировка по возрастанию по name для элементов Checklist
    func sortChecklists() {
        lists.sort { list1, list2 in
            return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
        }
    }
    
    // Устанавливаем значение по-умолчанию для ключей в UserDefaults
    func registerDefaults() {
        let dictionary = [checklistIndexUD: -1, firstTimeUD: true] as [String: Any]
        UserDefaults.standard.register(defaults: dictionary) // Устанавливаем значение по-умолчанию (-1) для ключа "ChecklistIndex"
    }
    
    // Выбранные элемент в списке. Это computed property
    var indexOfSelectedChecklist: Int {
        get {
            return userDefaults.integer(forKey: checklistIndexUD)
        }
        
        set {
            userDefaults.set(newValue, forKey: checklistIndexUD)
            userDefaults.synchronize()
        }
    }
    
    // Запуск в первый раз
    func handleFirstTime() {
        let firstTime = userDefaults.bool(forKey: firstTimeUD)
        
        if firstTime {
            // Создадим заготовку со списком под названием "List"
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            
            // Обновление данных в UserDefaults
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: firstTimeUD) // Теперь приложение запустить со значением "НЕ ПЕРВЫЙ ЗАПУСК" и этот код не будет выполняться снова.
            userDefaults.synchronize()
        }
    }
    
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID") // если нет значения для этого ключа, default value равно 0
        
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize() // Немедленно сохранить данные на диск
        return itemID
    }
    
    // Путь к директории с файлом
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths)
        return paths[0]
    }
    
    // Полный путь к файлу, включая имя файла
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklist.plist")
    }
    
    // Сохранение данных в plist
    func saveChecklists() {
        let encoder = PropertyListEncoder() // Объект который кодирует в тип данных для сохранения как plist
        
        do {
            let data = try encoder.encode(lists) // конвертирует массив LISTS в блок двоичных данных
            
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic) // сохраняет данные в файл по адресу dataFilePath()
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    //     Загрузка данных из plist
    func loadChecklists() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) { // возвратить nil если ошибка получения данных (try?)
            let decoder = PropertyListDecoder() // объект для декодирования из бинарных файлов.
            
            do {
                lists = try decoder.decode([Checklist].self, from: data)
                sortChecklists()
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }

}
