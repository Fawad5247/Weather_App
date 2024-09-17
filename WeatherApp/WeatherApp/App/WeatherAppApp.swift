//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Fawad Akthar on 15/09/2024.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            coordinator.start()
        }
    }
}
