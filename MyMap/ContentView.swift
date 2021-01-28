//
//  ContentView.swift
//  MyMap
//
//  Created by Finnis on 27/01/2021.
//

import SwiftUI
import CoreLocation
import HealthKit

struct ContentView: View {
    
    var body: some View {
        
        Button("Start recording route") {
            
            startWorkout()
        }
    }
    
    func startWorkout() {
        
        let locationManager = CLLocationManager()
        let store = HKHealthStore()
        
        // Start tracking the user.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        // Create the route builder.
        let routeBuilder = HKWorkoutRouteBuilder(healthStore: store, device: nil)
    }
    
    // MARK: - CLLocationManagerDelegate Methods.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Filter the raw data.
        let filteredLocations = locations.filter { (location: CLLocation) -> Bool in
            location.horizontalAccuracy <= 50.0
        }
        
        guard !filteredLocations.isEmpty else { return }
        
        // Add the filtered data to the route.
        routeBuilder.insertRouteData(filteredLocations) { (success, error) in
            if !success {
                // Handle any errors here.
            }
        }
    }
}
