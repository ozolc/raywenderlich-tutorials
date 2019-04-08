//
//  SelectQuestionGroupViewController.swift
//  RabbleWabble
//
//  Created by Maksim Nosov on 31/03/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

public class SelectQuestionGroupViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet internal var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }
    
    // MARK: - Properties
    public let questionGroupCaretaker = QuestionGroupCaretaker()
    public var questionGroups: [QuestionGroup] {
        return questionGroupCaretaker.questionGroups
    }
    private var selectedQuestionGroup: QuestionGroup! {
        get { return questionGroupCaretaker.selectedQuestionGroup }
        set { questionGroupCaretaker.selectedQuestionGroup = newValue }
    }
    private let appSettings = AppSettings.shared
    
    // MARK: - View Lifecycle
    public override func viewDidLoad() {
        questionGroups.forEach {
            print("\($0.title): " + "correctCount \($0.score.correctCount), " + "incorrectCount \($0.score.incorrectCount)")
        }
    }
}

// MARK: - UITableViewDataSource
extension SelectQuestionGroupViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionGroups.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionGroupCell", for: indexPath) as! QuestionGroupCell
        let questionGroup = questionGroups[indexPath.row]
        cell.titleLabel.text = questionGroup.title
        
        // 1
        questionGroup.score.runningPercentage.addObserver(cell, options: [.initial, .new]) {
            // 2
            [weak cell] (percentage, _) in
            // 3
            DispatchQueue.main.async {
                // 4
                cell?.percentageLabel.text = String(format: "%.0f %%", round(100 * percentage))
            }
        }
        
        return cell
    }
}

extension SelectQuestionGroupViewController: UITableViewDelegate {
    
    // 1
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedQuestionGroup = questionGroups[indexPath.row]
        return indexPath
    }
    
    // 2
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // 3
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? QuestionViewController else { return }
        viewController.questionStrategy = appSettings.questionStrategy(for: questionGroupCaretaker)
        viewController.delegate = self
    }
}

extension SelectQuestionGroupViewController: QuestionViewControllerDelegate {
    public func questionViewController(_ viewController: QuestionViewController, didCancel questionGroup: QuestionStrategy, at questionIndex: Int) {
        navigationController?.popToViewController(self, animated: true)
    }
    
    public func questionViewController(_ viewController: QuestionViewController, didComplete questionGroup: QuestionStrategy) {
        navigationController?.popToViewController(self, animated: true)
    }
    
}
