//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Anastasiya Sidarovich on 29.03.23.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {               
    func didReceiveNextQuestion(question: QuizQuestion?)
}
