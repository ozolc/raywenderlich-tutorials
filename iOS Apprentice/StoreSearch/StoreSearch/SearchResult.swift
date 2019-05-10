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
        return "Kind: \(kind ?? "None"), Name: \(name), Artist Name: \(artistName ?? "None")\n"
    }
    
    var artistName: String? = ""
    var trackName: String? = ""
    var kind: String? = ""
    var trackPrice: Double? = 0.0
    var currency = ""
    var artworkUrl60 = ""
    var artworkUrl100 = ""
    var trackViewUrl: String? = ""
    var primaryGenreName = ""
    
    var name: String {
        return trackName ?? ""
    }
}
