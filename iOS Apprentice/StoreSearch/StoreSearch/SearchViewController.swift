//
//  SearchViewController.swift
//  StoreSearch
//
//  Created by Maksim Nosov on 09/05/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchResults = [SearchResult]()
    var hasSearched = false // Флаг, что данные были найдены. Не пустой ответ от сервера.
    var isLoading = false // Флаг загрузки данных из сети. При значении true - отображается spinner загрузки.
    
    struct TableView {
        struct CellIdentifiers {
            static let searchResultCell = "SearchResultCell"
            static let nothingFoundCell = "NothingFoundCell"
            static let loadingCell = "LoadingCell"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0) // Добавить отступ для tableView на 64 points( 20 - StatusBar, 44 - SearchBar)
        
        // регистрация nib'ов для переиспользования identifiers из TableView.CellIdentifiers
        var cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil) // Загрузить nib файл из bundle
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
        
        searchBar.becomeFirstResponder() // Отобразить клавиатуру при загрузке в строке поиска
    }
    
    // MARK: - Helper Methods
    // Получение валидной строки для запроса
    func iTunesURL(searchText: String) -> URL {
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(format: "https://itunes.apple.com/search?term=%@&limit=200", encodedText)
        let url = URL(string: urlString)
        return url!
    }
    
    //     получение данных с сервера
    //    func performStoreRequest(with url: URL) -> Data? {
    //        do {
    //            return try Data(contentsOf: url) // JSONDecoder принимает Data тип
    //        } catch {
    //            print("Download Error: \(error.localizedDescription)")
    //            showNetworkError()
    //            return nil
    //        }
    //    }
    
    // Парсинг JSON с сервера в модель данных
    func parse(data: Data) -> [SearchResult] {
        do {
            let decoder = JSONDecoder() // для декодирования из JSON
            let result = try decoder.decode(ResultArray.self, from: data)
            return result.results
        } catch {
            print("JSON error: \(error)")
            return [] // Если получили ошибку - возвращает пустой массив [SearchResult]
        }
    }
    
    // Alert при возникновении ошибки во время сетевого запроса
    func showNetworkError() {
        let alert = UIAlertController(title: "Whoops...", message: "There was an error accessing the iTunes Store" + " Please try again.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    // Этот метод срабатывает, когда пользователь нажимает Search button на клавиатуре
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder() // Убрать клавиатуру
            
            isLoading = true
            tableView.reloadData()
            
            hasSearched = true
            searchResults = []
            
            let url = self.iTunesURL(searchText: searchBar.text!) // Создать URL объект
            
            let session = URLSession.shared // Получить shared объект для кеширования, cookies и др.
            
            // Создать data task для получения данных из url. Код из completionHandler будет вызван когда data task получит ответ от сервера.
            // error - ошибка при получении данных
            // response - код ответа и заголовки от сервера
            // data - данные, полученные от сервера (в данном случае JSON)
            
            // Асинхронный вызов кода в URLSession.
            // Код запускается в background thread, тем самым не блокирует main thread - экран приложения не блокируется во время запроса данных из сети.
            let dataTask = session.dataTask(with: url, completionHandler: { data, response, error in
                
                print("On main thread? " + (Thread.current.isMainThread ? "Yes" : "No"))
                
                if let error = error {
                    print("Failure! \(error.localizedDescription)")
                    return
                }
                
                if let data = data {
                    self.searchResults = self.parse(data: data) // Помещает полученный массив из Интернет в searchResults (модель данных)
                    
                    // Сортировка полученных данных JSON по полю name (Заголовок)
                    self.searchResults.sort { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
                    // searchResults.sort { $0 < $1 } // Использование перегруженного оператора "<" в SearchResult.swift
                    // searchResults.sort(by: >) // Короткая версия использования перегрузки оператора ">" сортирующую по убыванию по artist (Имя автора)
                    
                    // После получения данных, обновить UI в main потоке. Остановить анимацию spinner'a
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.tableView.reloadData()
                    }
                    
                    return
                } // Конец data
                
                // Этот код запускается, только если что-то пошло не так
                DispatchQueue.main.async {
                    self.hasSearched = false
                    self.isLoading = false
                    self.tableView.reloadData()
                    self.showNetworkError()
                }
                
            }) // Конец completionHandler
            
            dataTask.resume() // запустить data task. Он выполняется в background thread асинхронно. Ответ может прийти не сразу.
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        } else if !hasSearched {
            return 0
        } else if searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
            
            // Создать spinner для оповещения пользователя о загрузке данных из сети
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating() // Запуск анимации spinner
            return cell
            
        } else if searchResults.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
            
            let searchResult = searchResults[indexPath.row]
            if searchResult.artist.isEmpty {
                cell.artistNameLabel.text = "Unknown"
            } else {
                cell.artistNameLabel.text = String(format: "%@ (%@)", searchResult.artist, searchResult.type)
            }
            cell.nameLabel.text = searchResult.name
            
            
            return cell
        }
    }
    
    // Снять выделение с ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // Если нет данных в модели - выделить ячейки невозможно
        if searchResults.count == 0 || isLoading {
            return nil
        } else {
            // Разрешить выделение ячейки
            return indexPath
        }
    }
}
