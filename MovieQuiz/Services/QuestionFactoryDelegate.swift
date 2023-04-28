//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Anastasiya Sidarovich on 29.03.23.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {               
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
    func switchToNextQuestion()
    func isLastQuestion() -> Bool
    func resetQuestionIndex()
    func restartGame()
    func convert(model: QuizQuestion) -> QuizStepViewModel
    func yesButtonClicked()
    func noButtonClicked()
    func didAnswer(isYes: Bool)
    func didAnswer(isCorrectAnswer: Bool)
    func didRecieveNextQuestion(question: QuizQuestion?)
    func makeResultMessage() -> String
}
