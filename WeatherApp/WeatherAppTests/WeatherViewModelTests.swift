//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Fawad Akthar on 16/09/2024.
//

import XCTest
@testable import WeatherApp

class WeatherViewModelTests: XCTestCase {
    
    var viewModel: WeatherViewModel!
    var mockWeatherService: MockWeatherService!
    
    override func setUp() {
        super.setUp()
        mockWeatherService = MockWeatherService()
        viewModel = WeatherViewModel(weatherService: mockWeatherService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockWeatherService = nil
        super.tearDown()
    }
    
    func testFetchWeatherSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch weather successfully")
        
        let mockWeather = WeatherResponse(
            coord: Coordinates(lon: 10.0, lat: 20.0),
            weather: [WeatherCondition(id: 1, main: "Clear", description: "clear sky", icon: "01d")],
            base: "stations",
            main: MainWeather(temp: 25.0, feels_like: 24.5, temp_min: 22.0, temp_max: 28.0, pressure: 1012, humidity: 80),
            visibility: 10000,
            wind: Wind(speed: 5.0, deg: 180),
            clouds: Clouds(all: 0),
            dt: 1618317040,
            sys: Sys(type: 1, id: 1234, message: nil, country: "US", sunrise: 1618282134, sunset: 1618333901),
            timezone: -14400,
            id: 5128581,
            name: "Test City",
            cod: 200
        )
        
        mockWeatherService.mockWeatherResponse = mockWeather
        
        // When
        viewModel.fetchWeather(for: "Test City")
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.viewModel.weather?.name, "Test City")
            XCTAssertEqual(self.viewModel.weather?.main.temp, 25.0)
            XCTAssertEqual(self.viewModel.weather?.main.humidity, 80)
            XCTAssertEqual(self.viewModel.weather?.weather.first?.description, "clear sky")
            XCTAssertEqual(self.viewModel.weather?.sys.country, "US")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchWeatherFailure() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch weather failure")
        
        let mockError = NSError(domain: "Test Error", code: 123, userInfo: [NSLocalizedDescriptionKey: "Something went wrong"])
        mockWeatherService.mockError = mockError
        
        // When
        viewModel.fetchWeather(for: "Test City")
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNil(self.viewModel.weather)
            XCTAssertEqual(self.viewModel.errorMessage, "Something went wrong")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchWeatherWithCoordinatesSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch weather with coordinates successfully")
        
        let mockWeather = WeatherResponse(
            coord: Coordinates(lon: 10.0, lat: 20.0),
            weather: [WeatherCondition(id: 1, main: "Clear", description: "clear sky", icon: "01d")],
            base: "stations",
            main: MainWeather(temp: 25.0, feels_like: 24.5, temp_min: 22.0, temp_max: 28.0, pressure: 1012, humidity: 80),
            visibility: 10000,
            wind: Wind(speed: 5.0, deg: 180),
            clouds: Clouds(all: 0),
            dt: 1618317040,
            sys: Sys(type: 1, id: 1234, message: nil, country: "US", sunrise: 1618282134, sunset: 1618333901),
            timezone: -14400,
            id: 5128581,
            name: "Test City",
            cod: 200
        )
        
        mockWeatherService.mockWeatherResponse = mockWeather
        
        // When
        viewModel.fetchWeather(forLatitude: 20.0, longitude: 10.0)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.viewModel.weather?.name, "Test City")
            XCTAssertEqual(self.viewModel.weather?.main.temp, 25.0)
            XCTAssertEqual(self.viewModel.weather?.main.humidity, 80)
            XCTAssertEqual(self.viewModel.weather?.sys.country, "US")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadLastSearchedCity() {
        // Given
        let lastCity = "Last Searched City"
        UserDefaults.standard.set(lastCity, forKey: "LastSearchedCity")
        
        // When
        let loadedCity = viewModel.loadLastSearchedCity()
        
        // Then
        XCTAssertEqual(loadedCity, lastCity)
    }
}


