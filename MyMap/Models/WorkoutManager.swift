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
    
    /// - Tag: DeclareSessionBuilder
    let healthStore = HKHealthStore()
    var builder: HKWorkoutBuilder!
    var routeBuilder: HKWorkoutRouteBuilder!
    var locationManager: CLLocationManager!
    var accumulatedLocations: [CLLocation]!
    
    // Publish the following:
    // - elapsed time
    
    /// - Tag: Publishers
    @Published var elapsedSeconds: Int = 0
    
    // The app's workout state.
    var running: Bool = false
    
    /// - Tag: TimerSetup
    // The cancellable holds the timer publisher.
    var start: Date = Date()
    var cancellable: Cancellable?
    var accumulatedTime: Int = 0
    
    // Set up and start the timer.
    func setUpTimer() {
        start = Date()
        cancellable = Timer.publish(every: 0.1, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.elapsedSeconds = self.incrementElapsedTime()
            }
    }
    
    // Calculate the elapsed time.
    func incrementElapsedTime() -> Int {
        let runningTime: Int = Int(-1 * (self.start.timeIntervalSinceNow))
        return self.accumulatedTime + runningTime
    }
    
    // Provide the workout configuration.
    func workoutConfiguration() -> HKWorkoutConfiguration {
        /// - Tag: WorkoutConfiguration
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .running
        configuration.locationType = .outdoor
        
        return configuration
    }
    
    // Start the workout.
    func startWorkout() {
        
        // Start the timer.
        setUpTimer()
        self.running = true
        
        // Create the session and obtain the workout builder.
        /// - Tag: CreateWorkout
        do {
            // Create the route builder.
            routeBuilder = HKWorkoutRouteBuilder(healthStore: healthStore, device: nil)
        } catch {
            // Handle any exceptions.
            return
        }
        
        // Setup location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        // Setup session and builder.
        
        // Set the workout builder's data source.
        /// - Tag: SetDataSource
        
        // Start the workout session and begin data collection.
        /// - Tag: StartSession
        
        // Start tracking the user.
        locationManager.startUpdatingLocation()
        builder.beginCollection(withStart: Date()) { (success, error) in
            // The workout has started.
        }
    }
    
    // MARK: - State Control
    func togglePause() {
        // If you have a timer, then the workout is in progress, so pause it.
        if running {
            self.pauseWorkout()
        } else {// if session.state == .paused { // Otherwise, resume the workout.
            resumeWorkout()
        }
    }
    
    func pauseWorkout() {
        // Stop tracking user
        locationManager.stopUpdatingLocation()
        // Pause the workout.
        
        // Stop the timer.
        cancellable?.cancel()
        // Save the elapsed time.
        accumulatedTime = elapsedSeconds
        running = false
    }
    
    func resumeWorkout() {
        // Start tracking user
        locationManager.startUpdatingLocation()
        // Resume the workout.
        
        // Start the timer.
        setUpTimer()
        running = true
    }
    
    func endWorkout() {
        //Stop tracking user
        locationManager.stopUpdatingLocation()
        // End the workout session.
        
        cancellable?.cancel()
    }
    
    func resetWorkout() {
        // Reset the published values.
        DispatchQueue.main.async {
            self.elapsedSeconds = 0
            self.activeCalories = 0
            self.heartrate = 0
            self.distance = 0
        }
    }
    
    func finishWorkoutBuilder() {
        
        builder.endCollection(withEnd: Date()) { (success, error) in
            
            self.builder.finishWorkout { (workout, error) in
                
                // Optionally display a workout summary to the user.
                
                guard workout != nil else {
                    // Handle any errors here.
                    return
                }
                
                // Do something with the workout here:
                
                self.associateRouteData(workout: workout!)
                
                self.resetWorkout()
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension WorkoutManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        print(locations)
        
        // Filter the raw data.
        let filteredLocations = locations.filter { (location: CLLocation) -> Bool in
            location.horizontalAccuracy <= 50.0
        }
        
        guard !filteredLocations.isEmpty else { return }
        
        // Add the filtered data to the route.
        routeBuilder.insertRouteData(filteredLocations) { (success, error) in
            
            if !success {
                
                print("Error inserting route data")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error)
    }
    
    func associateRouteData(workout: HKWorkout){
        
        print(workout)
        
        // Create, save, and associate the route with the provided workout.
        routeBuilder.finishRoute(with: workout, metadata: nil) { (newRoute, error) in

            guard newRoute != nil else {
                // Handle any errors here.
                return
            }

            // Optional: Do something with the route here.
            
            print(newRoute)
        }
        
        print(workout)
    }
}
