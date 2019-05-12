//
//  Search.swift
//  StoreSearch
//
//  Created by Maksim Nosov on 12/05/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

class Search {
    
    enum State {
        case notSearchedYet // Поиск еще не производился
        case loading // Загрузка данных из сети. При значении true - отображается spinner загрузки.
        case noResult // После поиска на сервере - данных в ответе нет.
        case results([SearchResult]) // Когда поиск успешен массив с данными
    }
    
    enum Category: Int {
        case all = 0
        case music = 1
        case software = 2
        case ebooks = 3
        
        // computed выражение для возврата raw значения. Используется в iTunesURL(:,:)
        var type: String {
            switch self {
            case .all: return ""
            case .music: return "musicTrack"
            case .software: return "software"
            case .ebooks: return "ebook"
            }
        }
    }
    
    private(set) var state: State = .notSearchedYet // Текущее состояние Search состояний.
    private var dataTask: URLSessionDataTask? // Ссылка на data task, для отмена запроса, пока он выполняется. Поэтому он вынесен за пределы метода, где он выполняется - searchBarSearchButtonClicked(_:). Опциональный, т.к. нет data task пока пользователь не запустит поиск.
    
    typealias SearchComplete = (Bool) -> Void // Closure принимающий параметр Bool
    
    // Метод выполнения поиска
    func performSearch(for text: String, category: Category, completion: @escaping SearchComplete) {
        if !text.isEmpty {
            dataTask?.cancel() // Если data task активен - отменить его. Старый поиск не будет возвращен, на случай если запустить новый во время выполнения текущего.
            
            let url = self.iTunesURL(searchText: text, category: category) // Создать URL объект
            let session = URLSession.shared // Получить shared объект для кеширования, cookies и др.
            
            // Создать data task для получения данных из url. Код из completionHandler будет вызван когда data task получит ответ от сервера.
            // error - ошибка при получении данных
            // response - код ответа и заголовки от сервера
            // data - данные, полученные от сервера (в данном случае JSON)
            
            // Асинхронный вызов кода в URLSession.
            // Код запускается в background thread, тем самым не блокирует main thread - экран приложения не блокируется во время запроса данных из сети.
            dataTask = session.dataTask(with: url, completionHandler: { data, response, error in
                
                var newState = State.notSearchedYet
                
                // Был ли поиск остановлен?
                var success = false
                
                if let error = error as NSError?, error.code == -999 {
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                    var searchResults = self.parse(data: data) // Помещает полученный массив из Интернет в searchResults (модель данных)
                    if searchResults.isEmpty {
                        newState = .noResult
                    } else {
                        // Сортировка полученных данных JSON по полю name (Заголовок)
                        searchResults.sort { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
                        // searchResults.sort { $0 < $1 } // Использование перегруженного оператора "<" в SearchResult.swift
                        // searchResults.sort(by: >) // Короткая версия использования перегрузки оператора ">" сортирующую по убыванию по artist (Имя автора)
                        newState = .results(searchResults)
                    }
                    success = true
                }
                
                DispatchQueue.main.async {
                    self.state = newState
                    completion(success)
                }
                
            }) // Конец completionHandler
            dataTask?.resume() // запустить data task. Он выполняется в background thread асинхронно. Ответ может прийти не сразу.
        }
    }
    
    // Получение валидной строки для запроса
    private func iTunesURL(searchText: String, category: Category) -> URL {
        let kind = category.type
        
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
