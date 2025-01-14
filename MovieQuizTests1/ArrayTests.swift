//
//  ArrayTests.swift
//  MovieQuizTests1
//
//  Created by Anastasiya Sidarovich on 27.04.23.
//

import Foundation
import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    
    func testGetValueInRange() throws { // тест на успешное взятие элемента по индексу
        // Given
        let array = [1, 8, 2, 3, 5]
        // When
        let value = array[safe: 2]
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutOfRange() throws { // тест на взятие элемента по неправильному индексу
        // Given
        let array = [1, 8, 2, 3, 5]
        // When
        let value = array[safe: 20]
        // Then
        XCTAssertNil(value)
    }
    
}
