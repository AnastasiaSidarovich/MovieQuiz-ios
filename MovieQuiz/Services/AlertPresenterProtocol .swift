//
//  AlertPresenterProtocol .swift
//  MovieQuiz
//
//  Created by Anastasiya Sidarovich on 14.04.23.
//

import Foundation

protocol AlertPresenterProtocol {
    func presentAlert(model: AlertModel, accessibilityIdentifier: String?)
}
