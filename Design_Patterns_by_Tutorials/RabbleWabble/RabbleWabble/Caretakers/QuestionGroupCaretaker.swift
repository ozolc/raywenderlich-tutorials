//
//  QuestionGroupCaretaker.swift
//  RabbleWabble
//
//  Created by Maksim Nosov on 05/04/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

// 1
public final class QuestionGroupCaretaker {
    
    // MARK: - Properties
    // 2
    private let fileName = "QuestionGroupData"
    public var questionGroups: [QuestionGroup] = []
    public var selectedQuestionGroup: QuestionGroup!
    
    // MARK: - Object Lifecycle
    public init() {
        // 3
        loadQuestionGroup()
    }
    
    // 4
    private func loadQuestionGroup() {
        if let questionGroups = try? DiskCaretaker.retrieve([QuestionGroup].self, from: fileName) {
            self.questionGroups = questionGroups
        } else {
            let bundle = Bundle.main
            let url = bundle.url(forResource: fileName, withExtension: "json")!
            self.questionGroups = try! DiskCaretaker.retrieve([QuestionGroup].self, from: url)
            try! save()
        }
    }
    
    // MARK: - Instance Methods
    // 5
    public func save() throws {
        try DiskCaretaker.save(questionGroups, to: fileName)
    }
}
