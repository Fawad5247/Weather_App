//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Fawad Akthar on 15/09/2024.
//

import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherResponse?
    @Published var errorMessage: String?
    
    private let weatherService: WeatherService
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    func fetchWeather(for city: String) {
        weatherService.fetchWeather(for: city) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self?.weather = weather
                    self?.saveLastSearchedCity(city) // saving last searched city
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func fetchWeather(forLatitude lat: Double, longitude lon: Double) {
           weatherService.fetchWeather(forLatitude: lat, longitude: lon) { [weak self] result in
               DispatchQueue.main.async {
                   switch result {
                   case .success(let weather):
                       self?.weather = weather
                       self?.saveLastSearchedCity(weather.name) // saving last searched city
                   case .failure(let error):
                       self?.errorMessage = error.localizedDescription
                   }
               }
           }
       }
    
    // To save LastSearch in UserDefaults
    private func saveLastSearchedCity(_ city: String) {
        UserDefaults.standard.set(city, forKey: "LastSearchedCity")
    }
    
    // To load LastSearch from UserDefaults
    func loadLastSearchedCity() -> String? {
        return UserDefaults.standard.string(forKey: "LastSearchedCity")
    }
}
