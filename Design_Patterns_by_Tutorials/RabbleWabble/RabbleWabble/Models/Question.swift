//
//  Question.swift
//  RabbleWabble
//
//  Created by Maksim Nosov on 30/03/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

public class Question: Codable {
    public let answer: String
    public let hint: String?
    public let prompt: String
    
    public init(answer: String, hint: String?, prompt: String) {
        self.answer = answer
        self.hint = hint
        self.prompt = prompt
    }
}
