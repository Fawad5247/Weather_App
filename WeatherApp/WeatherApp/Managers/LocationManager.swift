//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Fawad Akthar on 15/09/2024.
//

import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var locationError: String?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check the authorization status on init
        checkLocationAuthorization()
    }
    
    // This method checks the current authorization status and acts accordingly
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            // If already authorized, request location updates
            locationManager.requestLocation()
        case .notDetermined:
            // If not determined, request permission
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            // Handle cases where permission was denied
            locationError = "Location access denied. Please enable it in settings."
        @unknown default:
            // Handle unknown cases
            locationError = "Unknown authorization status."
        }
    }
    
    // Delegate method triggered when the authorization status changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    // Request the current location once permission is granted
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first?.coordinate {
            self.location = location
        }
    }
    
    // Handle location updates failure
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = error.localizedDescription
    }
}


