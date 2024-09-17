//
//  MockWeatherService.swift
//  WeatherAppTests
//
//  Created by Fawad Akthar on 16/09/2024.
//

import XCTest
@testable import WeatherApp

class MockWeatherService: WeatherService {
    var mockWeatherResponse: WeatherResponse?
    var mockError: Error?
    
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        if let error = mockError {
            completion(.failure(error))
        } else if let weather = mockWeatherResponse {
            completion(.success(weather))
        }
    }
    
    func fetchWeather(forLatitude lat: Double, longitude lon: Double, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        if let error = mockError {
            completion(.failure(error))
        } else if let weather = mockWeatherResponse {
            completion(.success(weather))
        }
    }
}
