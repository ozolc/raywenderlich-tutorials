//
//  SequentalQuestionStrategy.swift
//  RabbleWabble
//
//  Created by Maksim Nosov on 02/04/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

public class SequentalQuestionStrategy: BaseQuestionStrategy {
   
    public convenience init(questionGroupCaretaker: QuestionGroupCaretaker) {
        let questionGroup = questionGroupCaretaker.selectedQuestionGroup!
        let questions = questionGroup.questions
        self.init(questionGroupCaretaker: questionGroupCaretaker, questions: questions)
    }
}
