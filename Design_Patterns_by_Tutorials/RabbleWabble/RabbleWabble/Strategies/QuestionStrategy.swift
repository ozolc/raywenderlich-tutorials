//
//  QuestionStrategy.swift
//  RabbleWabble
//
//  Created by Maksim Nosov on 02/04/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

public protocol QuestionStrategy: class {
    // 1
    var title: String { get }
    
    // 2
    var correctCount: Int { get }
    var incorrectCount: Int { get }
    
    // 3
    func advanceToNextQuestion() -> Bool
    
    // 4
    func currentQuestion() -> Question
    
    // 5
    func markQuestionCorrect(_ question: Question)
    func markQuestionIncorrect(_ question: Question)
    
    // 6
    func questionIndexTitle() -> String
}
