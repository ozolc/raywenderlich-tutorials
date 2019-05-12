//
//  SearchResult.swift
//  StoreSearch
//
//  Created by Maksim Nosov on 09/05/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

// Перегрузка оператора "<" для сортировки по возрастанию
func < (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
}

// Перегрузка оператора ">" для сортировки по убыванию
func > (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.artist.localizedStandardCompare(rhs.artist) == .orderedDescending
}

class ResultArray: Codable {
    var resultCount = 0
    var results = [SearchResult]()
}

class SearchResult: Codable, CustomStringConvertible {
    // CustomStringConvertible - протокол позволяет объекту иметь свое текстовое представление
    var description: String {
        return "Kind: \(kind ?? "None"), Name: \(name), Artist Name: \(artistName ?? "None")\n"
    }
    
    var artistName: String? = ""
    var trackName: String? = ""
    var trackViewUrl: String?
    var kind: String? = ""
    var trackPrice: Double? = 0.0
    var currency = ""
    
    var imageSmall = ""
    var imageLarge = ""
    
    var collectionName: String?
    var collectionViewUrl: String?
    var collectionPrice: Double?
    var itemPrice: Double?
    var itemGenre: String?
    var bookGenre: [String]?
    
    // Изменил имя свойств получаемых из JSON
    // Если используется CodingKey enum, необходимо предоставить case для всех свойств класса
    enum CodingKeys: String, CodingKey {
        case imageSmall = "artworkUrl60"
        case imageLarge = "artworkUrl100"
        case itemGenre = "primaryGenreName"
        case bookGenre = "genres"
        case itemPrice = "price"
        case kind, artistName, currency
        case trackName, trackPrice, trackViewUrl
        case collectionName, collectionViewUrl, collectionPrice
    }
    
    var name: String {
        return trackName ?? collectionName ?? "" // Nil- coalescing. Пытается развернуть опционал.Если trackName - nil, то пробует развернуть collectionName. Если тоже nil - то возратить пустую строку ""
    }
    
    var storeURL: String {
        return trackViewUrl ?? collectionViewUrl ?? ""
    }
    
    var price: Double {
        return trackPrice ?? collectionPrice ?? itemPrice ?? 0.0
    }
    
    var genre: String {
        if let genre = itemGenre {
            return genre
        } else if let genres = bookGenre {
            return genres.joined(separator: ", ") //Элемент массива представить как последовательность соединенных ", "
        }
        
        return ""
    }
    
    var type:String {
        let kind = self.kind ?? "audiobook"
        
        // Удобное представление для возращаемого типа продукта (kind)
        switch kind {
        case "album":
            return NSLocalizedString("Album", comment: "Localized kind: Album")
        case "audiobook":
            return NSLocalizedString("Audio Book", comment: "Localized kind: Audio Book")
        case "book":
            return NSLocalizedString("Book", comment: "Localized kind: Book")
        case "ebook":
            return NSLocalizedString("E-Book", comment: "Localized kind: E-Book")
        case "feature-movie":
            return NSLocalizedString("Movie", comment: "Localized kind: Feature Movie")
        case "music-video":
            return NSLocalizedString("Music Video", comment: "Localized kind: Music Video")
        case "podcast":
            return NSLocalizedString("Podcast", comment: "Localized kind: Podcast")
        case "software":
            return NSLocalizedString("App", comment: "Localized kind: Software")
        case "song":
            return NSLocalizedString("Song",  comment: "Localized kind: Song")
        case "tv-episode":
            return NSLocalizedString("TV Episode", comment: "Localized kind: TV Episode")
        default:
            return kind
        }
    }
    
    var artist: String {
        return artistName ?? ""
    }
    
    
}
