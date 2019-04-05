//
//  RandomQuestionStrategy.swift
//  RabbleWabble
//
//  Created by Maksim Nosov on 02/04/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import GameplayKit.GKRandomSource

public class RandomQuestionStrategy: BaseQuestionStrategy {
    
    public convenience init(questionGroupCaretaker: QuestionGroupCaretaker) {
        let questionGroup = questionGroupCaretaker.selectedQuestionGroup!
        let randomSource = GKRandomSource.sharedRandom()
        let questions = randomSource.arrayByShufflingObjects(in: questionGroup.questions) as! [Question]
        self.init(questionGroupCaretaker: questionGroupCaretaker, questions: questions)
    }
}

