//
//  WorkoutManager.swift
//  MyMap
//
//  Created by Finnis on 13/02/2021.
//

import Foundation
import HealthKit
import Combine
import CoreLocation

class WorkoutManager: NSObject, ObservableObject {
    
    let healthStore = HKHealthStore()
    var workoutBuilder: HKWorkoutBuilder!
    var routeBuilder: HKWorkoutRouteBuilder!
    var locationManager: CLLocationManager!
    
    // Publish elapsed time, accumulated locations and workout state
    @Published var elapsedSeconds: Int = 0
    @Published var accumulatedLocations: [CLLocation] = []
    @Published var state: WorkoutState = .notStarted
    
    // Cancellable holds the timer publisher
    var start: Date = Date()
    var cancellable: Cancellable?
    var accumulatedTime: Int = 0
    
    // Set up and start the timer
    func setUpTimer() {
        start = Date()
        cancellable = Timer.publish(every: 0.1, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.elapsedSeconds = self.incrementElapsedTime()
            }
    }
    
    // Calculate the elapsed time
    func incrementElapsedTime() -> Int {
        // Ensure it takes into account a resumed workout
        let runningTime: Int = Int(-1 * (self.start.timeIntervalSinceNow))
        
        return self.accumulatedTime + runningTime
    }
    
    // Provide the workout configuration
    func workoutConfiguration() -> HKWorkoutConfiguration {
        // Create an outdoor run configuration
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .running
        configuration.locationType = .outdoor
        
        return configuration
    }
    
    // Start the workout
    func startWorkout() {
        // Start the timer
        setUpTimer()
        
        // Create the workout builder
        workoutBuilder = HKWorkoutBuilder(healthStore: healthStore, configuration: workoutConfiguration(), device: .local())
        
        // Create the route builder
        routeBuilder = HKWorkoutRouteBuilder(healthStore: healthStore, device: nil)
        
        // Create the location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Request location services authorisation
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        // Allow updates to occur in the background
        locationManager.allowsBackgroundLocationUpdates = true
        
        // Start tracking the user
        locationManager.startUpdatingLocation()
        
        // Start the workout session and begin data collection
        workoutBuilder.beginCollection(withStart: Date()) { (success, error) in
            // The workout has started
            print("Workout Started")
        }
    }
    
    // MARK: - State Control
    func pauseWorkout() {
        // Stop tracking user
        locationManager.stopUpdatingLocation()
        // Stop the timer
        cancellable?.cancel()
        // Save the elapsed time
        accumulatedTime = elapsedSeconds
        
        state = .paused
        print("Workout Paused")
    }
    
    func resumeWorkout() {
        // Start tracking user
        locationManager.startUpdatingLocation()
        // Start the timer
        setUpTimer()
        
        state = .running
        print("Workout Resumed")
    }
    
    func endWorkout() {
        //Stop tracking user
        locationManager.stopUpdatingLocation()
        // Stop the timer
        cancellable?.cancel()
        
        if elapsedSeconds >= 60 {
            // End the workout session
            endWorkoutBuilderSession()
        }
        
        state = .notStarted
        print("Workout Ended")
        
        resetWorkout()
    }
    
    func resetWorkout() {
        // Reset the published values
        DispatchQueue.main.async {
            self.elapsedSeconds = 0
        }
        
        // Reset timer
        accumulatedTime = 0
        
        print("Workout Reset")
    }
    
    func endWorkoutBuilderSession() {
        
        // End workout data collection
        workoutBuilder.endCollection(withEnd: Date()) { (success, error) in
            
            if success {
            
                // Finish workout and save it to the health store
                self.workoutBuilder.finishWorkout { (workout, error) in
                    
                    if workout == nil {
                        
                        print("Error in saving workout to health store")
                    } else {
                        
                        print("The workout has been saved to the health store")
                        
                        // Create, save, and associate the route with the provided workout
                        self.routeBuilder.finishRoute(with: workout!, metadata: nil) { (newRoute, error) in
                            
                            if newRoute == nil {
                                
                                print("Error in associating workout route")
                            } else {
                                // Do something with the route here
                                print("Route data has been associated with the workout")
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension WorkoutManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        print("Locations: \(locations)")
        
        // Filter the raw data.
        let filteredLocations = locations.filter { (location: CLLocation) -> Bool in
            // Filter locations to an accuracy of 50m or less
            location.horizontalAccuracy <= 50.0
        }
        
        guard filteredLocations != [] else {
            // Handle any errors here
            print("All locations discarded")
            return
        }
        
        // Add the locations to the accumulated locations array
        DispatchQueue.main.async {
            // For each location in the filtered array
            for location in filteredLocations {
                
                self.accumulatedLocations.append(location)
            }
        }
        
        // Add the location data to the route
        routeBuilder.insertRouteData(filteredLocations) { (success, error) in
            
            if !success {
                
                print("Error in inserting route data")
            } else {
                
                print("Success in inserting route data")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        if let error = error as? CLError, error.code == .denied {
            
            // Location updates are not authorized.
            manager.stopUpdatingLocation()
            return
        }
        // Notify the user of any errors.
    }
}
