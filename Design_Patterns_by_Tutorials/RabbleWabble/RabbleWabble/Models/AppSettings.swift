//
//  AppSettings.swift
//  RabbleWabble
//
//  Created by Maksim Nosov on 04/04/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

public class AppSettings {
    // MARK: - Static Properties
    public static let shared = AppSettings()
    
    // MARK: - Instance Properties
    public var questionStrategyType: QuestionStrategyType {
        get {
            let rawValue = userDefaults.integer(forKey: Keys.questionStrategy)
            return QuestionStrategyType(rawValue: rawValue)!
        } set {
            userDefaults.set(newValue.rawValue, forKey: Keys.questionStrategy)
        }
    }
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Instance Methods
    public func questionStrategy(for questionGroupCaretaker: QuestionGroupCaretaker) -> QuestionStrategy {
        return questionStrategyType.questionStrategy(for: questionGroupCaretaker)
    }
    
    // MARK: - Object Lifecycle
    private init() { }
}

// MARK: - QuestionStrategyType
public enum QuestionStrategyType: Int, CaseIterable {
    
    case random
    case sequential
    
    // MARK: - Instance Methods
    public func title() -> String {
        switch self {
        case .random:
            return "Random"
        case .sequential:
            return "Sequental"
        }
    }
    
    public func questionStrategy(for questionGroupCaretaker: QuestionGroupCaretaker) -> QuestionStrategy {
        switch self {
        case .random:
            return RandomQuestionStrategy(questionGroupCaretaker: questionGroupCaretaker)
        case .sequential:
            return SequentalQuestionStrategy(questionGroupCaretaker: questionGroupCaretaker)
        }
    }
}

// ARK: - Keys
private struct Keys {
    static let questionStrategy = "questionStrategy"
}
