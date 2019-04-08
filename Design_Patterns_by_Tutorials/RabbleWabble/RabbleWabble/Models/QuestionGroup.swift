//
//  QuestionGroup.swift
//  RabbleWabble
//
//  Created by Maksim Nosov on 30/03/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

public class QuestionGroup: Codable {
    
    public class Score: Codable {
        public var correctCount: Int = 0 {
            didSet {
                updateRunningPercentege()
            }
        }
        public var incorrectCount: Int = 0 {
            didSet {
                updateRunningPercentege()
            }
        }        
        private func updateRunningPercentege() {
            runningPercentage.value = calculateRunningPercentage()
        }
        
        public init() { }
        
        public lazy var runningPercentage = Observable(calculateRunningPercentage())
        
        private func calculateRunningPercentage() -> Double {
            let totalCount = correctCount + incorrectCount
            guard totalCount > 0 else {
                return 0
            }
            
            return Double(correctCount) / Double(totalCount)
        }
        
        public func reset() {
            correctCount = 0
            incorrectCount = 0
        }
    }
    
    public let questions: [Question]
    public private(set) var score: Score
    public let title: String
    
    
    public init(questions: [Question],
                score: Score = Score(),
                title: String) {
        self.questions = questions
        self.score = score
        self.title = title
    }
}

