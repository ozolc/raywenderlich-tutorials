//
//  Search.swift
//  StoreSearch
//
//  Created by Maksim Nosov on 12/05/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

class Search {
    
    var searchResults = [SearchResult]()
    var hasSearched = false // Флаг, что данные были найдены. Не пустой ответ от сервера.
    var isLoading = false // Флаг загрузки данных из сети. При значении true - отображается spinner загрузки.
    private var dataTask: URLSessionDataTask? // Ссылка на data task, для отмена запроса, пока он выполняется. Поэтому он вынесен за пределы метода, где он выполняется - searchBarSearchButtonClicked(_:). Опциональный, т.к. нет data task пока пользователь не запустит поиск.
    
    typealias SearchComplete = (Bool) -> Void // Closure принимающий параметр Bool
    
    // Метод выполнения поиска
    func performSearch(for text: String, category: Int, completion: @escaping SearchComplete) {
        if !text.isEmpty {
            dataTask?.cancel() // Если data task активен - отменить его. Старый поиск не будет возвращен, на случай если запустить новый во время выполнения текущего.
            
            isLoading = true
            hasSearched = true
            searchResults = []
            
            let url = self.iTunesURL(searchText: text, category: category) // Создать URL объект
            let session = URLSession.shared // Получить shared объект для кеширования, cookies и др.
            
            // Создать data task для получения данных из url. Код из completionHandler будет вызван когда data task получит ответ от сервера.
            // error - ошибка при получении данных
            // response - код ответа и заголовки от сервера
            // data - данные, полученные от сервера (в данном случае JSON)
            
            // Асинхронный вызов кода в URLSession.
            // Код запускается в background thread, тем самым не блокирует main thread - экран приложения не блокируется во время запроса данных из сети.
            dataTask = session.dataTask(with: url, completionHandler: { data, response, error in
                
                // Был ли поиск остановлен?
                var success = false
                
                if let error = error as NSError?, error.code == -999 {
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                    self.searchResults = self.parse(data: data) // Помещает полученный массив из Интернет в searchResults (модель данных)
                    // Сортировка полученных данных JSON по полю name (Заголовок)
                    self.searchResults.sort { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
                    // searchResults.sort { $0 < $1 } // Использование перегруженного оператора "<" в SearchResult.swift
                    // searchResults.sort(by: >) // Короткая версия использования перегрузки оператора ">" сортирующую по убыванию по artist (Имя автора)
                    
                    print("Success!")
                    self.isLoading = false
                    success = true
                }
                
                if !success {
                    self.hasSearched = false
                    self.isLoading = false
                }
                
                DispatchQueue.main.async {
                    completion(success)
                }
                
            }) // Конец completionHandler
            dataTask?.resume() // запустить data task. Он выполняется в background thread асинхронно. Ответ может прийти не сразу.
        }
    }
    
    // Получение валидной строки для запроса
    private func iTunesURL(searchText: String, category: Int) -> URL {
        let kind: String
        switch category {
        case 1: kind = "musicTrack"
        case 2: kind = "software"
        case 3: kind = "ebook"
        default: kind = ""
        }
        
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = "https://itunes.apple.com/search?term=\(encodedText)&limit=200&entity=\(kind)"
        let url = URL(string: urlString)
        return url!
    }
    
    // Парсинг JSON с сервера в модель данных
    private func parse(data: Data) -> [SearchResult] {
        do {
            let decoder = JSONDecoder() // для декодирования из JSON
            let result = try decoder.decode(ResultArray.self, from: data)
            return result.results
        } catch {
            print("JSON error: \(error)")
            return [] // Если получили ошибку - возвращает пустой массив [SearchResult]
        }
    }
}
