//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Maksim Nosov on 09/05/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

class ResultArray: Codable {
    var resultCount = 0
    var results = [SearchResult]()
}

class SearchResult: Codable, CustomStringConvertible {
    // CustomStringConvertible - протокол позволяет объекту иметь свое текстовое представление
    var description: String {
        return "Kind: \(kind ?? "None"), Genre: \(genre), Name: \(name), Artist Name: \(artistName ?? "None")\n"
    }
    
    var artistName: String? = ""
    var trackName: String? = ""
    var kind: String? = ""
    var trackPrice: Double? = 0.0
    var currency = ""
    
    var imageSmall = ""
    var imageLarge = ""
    var storeURL: String? = ""
    var genre = ""
    
    // Изменил имя свойств получаемых из JSON
    // Если используется CodingKey enum, необходимо предоставить case для всех свойств класса
    enum CodingKeys: String, CodingKey {
        case imageSmall = "artworkUrl60"
        case imageLarge = "artworkUrl100"
        case storeURL = "trackViewUrl"
        case genre = "primaryGenreName"
        case kind, artistName, trackName
        case trackPrice, currency
    }
    
    var name: String {
        return trackName ?? ""
    }
}
