//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Fawad Akthar on 15/09/2024.
//

import SwiftUI

class AppCoordinator: ObservableObject {
    @Published var currentView: WeatherView
    
    init() {
        let networkManager = NetworkManager()
        let weatherVM = WeatherViewModel(weatherService: networkManager)
        self.currentView = WeatherView(viewModel: weatherVM)
    }
    
    func start() -> some View {
        return currentView
    }
}
