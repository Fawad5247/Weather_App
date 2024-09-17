//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Fawad Akthar on 15/09/2024.
//

import SwiftUI

struct WeatherView: View {
    @StateObject var viewModel: WeatherViewModel
    @StateObject var locationManager = LocationManager()
    
    @State private var city: String = ""
    
    var body: some View {
        VStack {
            HStack{
                HStack{
                    TextField("Enter city", text: $city.animation())
                        .padding()
                }
                .frame(height: 45)
                .background(.gray.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 25))
                
                //hide search button when textfield is empty
                if !city.isEmpty {
                    Button(action: {
                        viewModel.fetchWeather(for: city)
                    }, label: {
                        Text("Search")
                    })
                }
            }
            
            if let weather = viewModel.weather {
                // Display the weather information
                VStack {
                    Text("Weather in \(weather.name)")
                        .font(.title)
                    
                    // Display weather icon
                    if let icon = weather.weather.first?.icon {
                        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")) { image in
                            image
                                .resizable()
                                .frame(width: 100, height: 100)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    
                    Text("Temperature: \(weather.main.temp)°C")
                    Text("Humidity: \(weather.main.humidity)%")
                    Text("Condition: \(weather.weather.first?.description ?? "")")
                }
                .padding(.top, 30)
                
            }else if let location = locationManager.location {
                // check if there is not last search, show current location's weather
                if viewModel.loadLastSearchedCity() == nil {
                    Text("Fetching current location weather...")
                        .padding(.top, 30)
                        .onAppear {
                            viewModel.fetchWeather(forLatitude: location.latitude, longitude: location.longitude)
                        }
                }
            }else if let errorMessage = viewModel.errorMessage {
                // Display an error message
                Text(errorMessage)
                    .foregroundColor(.red)
            } else if let locationError = locationManager.locationError {
                // Display a location error message, if no last location found
                if viewModel.loadLastSearchedCity() == nil {
                    Text(locationError)
                        .foregroundColor(.red)
                }
            }
            
            Spacer()
        }
        .foregroundStyle(.white)
        .padding()
        .background(
            LinearGradient(colors: [.color1, .color2], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .onAppear {
            // initially check for last searched location
            if let lastCity = viewModel.loadLastSearchedCity() {
                viewModel.fetchWeather(for: lastCity)
            } else {
                // if no last searched, get current location's weather
                if let location = locationManager.location{
                    viewModel.fetchWeather(forLatitude: location.latitude, longitude: location.longitude)
                }
            }
        }
    }
}

