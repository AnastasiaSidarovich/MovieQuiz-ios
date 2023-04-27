//
//  MoviesLoadingProtocol.swift
//  MovieQuiz
//
//  Created by Anastasiya Sidarovich on 17.04.23.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}
