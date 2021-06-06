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
    // MARK: - Properties
    private let healthStore = HKHealthStore()
    private var workoutBuilder: HKWorkoutBuilder!
    private var routeBuilder: HKWorkoutRouteBuilder!
    private var locationManager: CLLocationManager!
    
    // Publish the following:
    // - Elapsed seconds
    // - Total distance travelled
    // - Accumulated locations from previous segments
    // - New locations from current segment
    // - Workout State
    @Published var elapsedSeconds: Int = 0
    @Published var distance: Double = 0
    @Published var accumulatedLocations: [[CLLocation]] = [[]]
    @Published var newLocations: [CLLocation] = []
    @Published var state: WorkoutState = .notStarted
    
    // Cancellable holds the timer publisher
    private var cancellable: Cancellable?
    private var startDate: Date = Date()
    private var accumulatedTime: Int = 0
    
    // MARK: - Initialiser
    override init() {
        super.init()
        // Start tracking the user
        setupLocationManager()
    }
    
    // MARK: - Private Methods
    private func startTimer() {
        // When this segment started
        startDate = Date()
        cancellable = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.elapsedSeconds = self.calculateElapsedTime()
            }
    }
    
    private func calculateElapsedTime() -> Int {
        // Time of this segment
        let segmentTime: Int = Int(Date().timeIntervalSince(startDate))
        // Total all segments' times
        return segmentTime + accumulatedTime
    }
    
    private func saveNewLocations() {
        // Save new locations when the workout is paused
        accumulatedLocations.append(newLocations)
        // Empty the new locations
        newLocations = []
    }
    
    // Setup the location manager to be used
    private func setupLocationManager() {
        // Create the location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        // Set accuracy
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        
        // Request location services authorisation
        locationManager.requestWhenInUseAuthorization()
        
        // Start tracking the user
        locationManager.startUpdatingLocation()
    }
    
    private func workoutConfiguration(workoutType: HKWorkoutActivityType) -> HKWorkoutConfiguration {
        // Provide the workout configuration
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = workoutType
        configuration.locationType = .outdoor
        
        return configuration
    }
    
    private func endWorkoutBuilderSession() {
        // End workout data collection
        workoutBuilder.endCollection(withEnd: Date()) { (success, error) in
            if success {
                
                // Finish workout and save it to the health store
                self.workoutBuilder.finishWorkout { (workout, error) in
                    if error != nil {
                        print("Error saving workout to health store")
                    } else {
                        print("Workout saved to health store")
                        
                        // Create, save, and associate the route with the provided workout
                        self.routeBuilder.finishRoute(with: workout!, metadata: nil) { (newRoute, error) in
                            if newRoute == nil {
                                print("Error associating workout route")
                            } else {
                                // Do something with the route here
                                print("Route data associated with workout")
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Workout State Control
    public func startWorkout(workoutType: HKWorkoutActivityType) {
        // Start the timer
        startTimer()
        
        // Create the workout builder
        workoutBuilder = HKWorkoutBuilder(healthStore: healthStore, configuration: workoutConfiguration(workoutType: workoutType), device: .local())
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
        state = .running
        print("Workout Started")
    }
    
    public func pauseWorkout() {
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
    
    public func resumeWorkout() {
        // Start the timer
        startTimer()
        // Start tracking user in the background
        locationManager.allowsBackgroundLocationUpdates = true
        
        // Workout resumed
        state = .running
        print("Workout Resumed")
    }
    
    public func endWorkout() {
        // Stop the timer
        cancellable?.cancel()
        // Stop tracking user in the background
        locationManager.allowsBackgroundLocationUpdates = false
        // End the workout session
        endWorkoutBuilderSession()
        
        // Reset workout
        resetWorkout()
        
        // Workout ended
        state = .notStarted
        print("Workout Ended")
    }
    
    private func resetWorkout() {
        // Reset the properties
        elapsedSeconds = 0
        distance = 0
        accumulatedTime = 0
        
        // Workout reset
        print("Workout Reset")
    }
}

// MARK: - CLLocationManager Delegate
extension WorkoutManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // Only add locations during a workout session
        if state == .running {
            guard locations != [] else {
                print("Locations discarded")
                return
            }
            
            // Add the locations to the new locations array
            for location in locations {
                // Get the distance from the previous location
                if let lastLocation = self.newLocations.last {
                    let delta: Double = location.distance(from: lastLocation)
                    self.distance += delta
                }
                newLocations.append(location)
            }
            
            // Add the locations to the route
            routeBuilder.insertRouteData(locations) { (success, error) in
                if !success {
                    print("Error inserting locations")
                } else {
                    // Success inserting locations
                }
            }
        }
    }
}
