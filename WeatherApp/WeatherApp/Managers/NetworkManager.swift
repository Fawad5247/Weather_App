//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Fawad Akthar on 15/09/2024.
//

import Foundation
import CoreLocation

protocol WeatherService {
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void)
    func fetchWeather(forLatitude lat: Double, longitude lon: Double, completion: @escaping (Result<WeatherResponse, Error>) -> Void)
}

class NetworkManager: WeatherService {
    private let apiKey = "eb1aaa667ffd05351ef799d1efac1f46"
    
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        performRequest(with: url, completion: completion)
    }
    
    func fetchWeather(forLatitude lat: Double, longitude lon: Double, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        performRequest(with: url, completion: completion)
    }
    
    private func performRequest(with url: URL, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let weather = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    completion(.success(weather))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
