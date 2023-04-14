//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Anastasiya Sidarovich on 14.04.23.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}
