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
    
    // Publish the following:
    //  - Elapsed seconds
    //  - Total distance travelled
    //  - Accumulated locations from previous segments
    //  - New locations from current segment
    @Published var elapsedSeconds: Int = 0
    @Published var distance: Double = 0
    @Published var accumulatedLocations: [[CLLocation]] = [[]]
    @Published var newLocations: [CLLocation] = []
    
    // The workout state
    public var state: WorkoutState = .notStarted
    
    // Cancellable holds the timer publisher
    var start: Date = Date()
    var cancellable: Cancellable?
    var accumulatedTime: Int = 0
    
    func startTimer() {
        // When this segment started
        start = Date()
        cancellable = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.elapsedSeconds = self.calculateElapsedTime()
            }
    }
    
    func calculateElapsedTime() -> Int {
        // Time of this segment
        let segmentTime: Int = Int(-1 * self.start.timeIntervalSinceNow)
        // Total all segments' times
        return segmentTime + accumulatedTime
    }
    
    func saveNewLocations() {
        // Save new locations when the workout is paused
        accumulatedLocations.append(newLocations)
        // Empty the new locations
        newLocations.removeAll()
    }
    
    // Setup the location manager to be used
    func setupLocationManager() {
        // Create the location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        // Request location services authorisation
        locationManager.requestWhenInUseAuthorization()
        
        // Start tracking the user
        locationManager.startUpdatingLocation()
    }
    
    func workoutConfiguration() -> HKWorkoutConfiguration {
        // Provide the workout configuration
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .cycling
        configuration.locationType = .outdoor
        
        return configuration
    }
    
    // MARK: - Workout State Control
    func startWorkout() {
        // Start the timer
        startTimer()
        
        // Create the workout builder
        workoutBuilder = HKWorkoutBuilder(healthStore: healthStore, configuration: workoutConfiguration(), device: .local())
        // Create the route builder
        routeBuilder = HKWorkoutRouteBuilder(healthStore: healthStore, device: nil)
        
        // Request location services authorisation
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        // Allow updates to occur in the background
        locationManager.allowsBackgroundLocationUpdates = true
        
        // Start the workout session and begin data collection
        workoutBuilder.beginCollection(withStart: Date()) { (success, error) in }
        
        // The workout has started
        self.state = .running
        print("Workout Started")
    }
    
    func pauseWorkout() {
        // Stop the timer
        cancellable?.cancel()
        // Save the elapsed time
        accumulatedTime = elapsedSeconds
        // Stop tracking user in the background
        locationManager.allowsBackgroundLocationUpdates = false
        // Save the new locations
        saveNewLocations()
        
        // Workout paused
        state = .paused
        print("Workout Paused")
    }
    
    func resumeWorkout() {
        // Start the timer
        startTimer()
        // Start tracking user in the background
        locationManager.allowsBackgroundLocationUpdates = true
        
        // Workout resumed
        state = .running
        print("Workout Resumed")
    }
    
    func endWorkout() {
        // Stop the timer
        cancellable?.cancel()
        // Stop tracking user in the background
        locationManager.allowsBackgroundLocationUpdates = false
        // End the workout session
        if elapsedSeconds >= 60 {
            endWorkoutBuilderSession()
        }
        
        // Workout ended
        state = .notStarted
        print("Workout Ended")
        
        // Reset workout
        resetWorkout()
    }
    
    func resetWorkout() {
        // Reset the published values
        DispatchQueue.main.async {
            self.elapsedSeconds = 0
            self.distance = 0
        }
        
        // Reset timer
        accumulatedTime = 0
        // Workout reset
        print("Workout Reset")
    }
    
    // MARK: - End Workout Session
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
    
    // MARK: - Init
    override init() {
        super.init()
        // Start tracking the user
        setupLocationManager()
    }
}

// MARK: - CLLocationManagerDelegate
extension WorkoutManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        print("User location Updated")
        
        // Only add locations during a workout session
        if state == .running {
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
            
            // Add the locations to the new locations array
            for location in filteredLocations {
                // Get the distance from the previous location
                if let lastLocation = self.newLocations.last {
                    
                    let delta: Double = location.distance(from: lastLocation)
                    self.distance += delta
                }
                self.newLocations.append(location)
            }
            
            // Add the locations to the route
            routeBuilder.insertRouteData(filteredLocations) { (success, error) in
                
                if !success {
                    
                    print("Error in inserting locations")
                } else {
                    
                    print("Success in inserting locations")
                }
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
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Handle errors
    }
}
