//
//  BaseQuestionStrategy.swift
//  RabbleWabble
//
//  Created by Maksim Nosov on 05/04/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

public class BaseQuestionStrategy: QuestionStrategy {
    
    public var correctCount: Int {
        get { return questionGroup.score.correctCount}
        set { questionGroup.score.correctCount = newValue }
    }
    public var incorrectCount: Int {
        get { return questionGroup.score.incorrectCount}
        set { questionGroup.score.incorrectCount = newValue }
    }
    private var questionGroupCaretaker: QuestionGroupCaretaker
    
    // 2
    private var questionGroup: QuestionGroup {
        return questionGroupCaretaker.selectedQuestionGroup
    }
    private var questionIndex = 0
    private var questions: [Question]
    
    // MARK: - Object Lifecycle
    // 3
    public init(questionGroupCaretaker: QuestionGroupCaretaker, questions: [Question]) {
        self.questionGroupCaretaker = questionGroupCaretaker
        self.questions = questions
    
    // 4
    self.questionGroupCaretaker.selectedQuestionGroup.score = QuestionGroup.Score()
    }
    
    // MARK: - QuestionStrategy
    public var title: String {
        return questionGroup.title
    }
    
    public func currentQuestion() -> Question {
        return questions[questionIndex]
    }
    
    public func advanceToNextQuestion() -> Bool {
        try? questionGroupCaretaker.save()
        guard questionIndex + 1 < questions.count else { return false }
        questionIndex += 1
        return true
    }
    
    public func markQuestionCorrect(_ question: Question) {
        correctCount += 1
    }
    
    public func markQuestionIncorrect(_ question: Question) {
        incorrectCount += 1
    }
    
    public func questionIndexTitle() -> String {
        return "\(questionIndex + 1)/\(questions.count)"
    }
}
