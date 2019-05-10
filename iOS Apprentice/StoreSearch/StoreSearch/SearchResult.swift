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
        return "Name: \(name), Artist Name: \(artistName ?? "None")"
    }
    
    var artistName: String? = ""
    var trackName: String? = ""
    
    var name: String {
        return trackName ?? ""
    }
}
