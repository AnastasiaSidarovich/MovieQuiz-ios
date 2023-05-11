//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Anastasiya Sidarovich on 27.04.23.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showResults()
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    func resetBorder()
    func enableOfButtons()
    func disableOfButtons()
}
