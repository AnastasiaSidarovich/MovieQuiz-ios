//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Anastasiya Sidarovich on 3.04.23.
//

import Foundation

struct AlertModel {
  let title: String
  let message: String
  let buttonText: String
  let completion: (() -> Void)?
}
