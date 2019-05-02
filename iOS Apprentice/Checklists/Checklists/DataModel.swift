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
    let checklistIndexUD = "ChecklistIndex"
    let userDefaults = UserDefaults.standard
    
    init() {
        // Загрузка данных из plist
        loadChecklists()
        // Регистрируем значение по-умолчанию
        registerDefaults()
    }
    
    func registerDefaults() {
        let dictionary = [checklistIndexUD: -1]
        UserDefaults.standard.register(defaults: dictionary) // Устанавливаем значение по-умолчанию (-1) для ключа "ChecklistIndex"
    }
    
    var indexOfSelectedChecklist: Int {
        get {
            return userDefaults.integer(forKey: checklistIndexUD)
        }
        
        set {
            userDefaults.set(newValue, forKey: checklistIndexUD)
            userDefaults.synchronize()
        }
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
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }

}
