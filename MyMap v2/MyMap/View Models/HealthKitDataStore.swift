//
//  HealthKitDataStore.swift
//  MyMap
//
//  Created by Finnis on 09/06/2021.
//

import Foundation
import HealthKit
import CoreLocation
import MapKit

class HealthKitDataStore {
    // MARK: - Properties
    var healthStore: HKHealthStore!
    
    public func requestAuthorisation(completion: @escaping (String?) -> Void) {
        // Check healthkit is available
        if !HKHealthStore.isHealthDataAvailable() {
            completion("Health data not available")
            return
        }
        healthStore = HKHealthStore()
        
        // Request authorisation to use health store
        // The quantity type to write to the health store
        let typesToShare: Set = [
            HKObjectType.workoutType(),
            HKSeriesType.workoutRoute()
        ]
        // The quantity type to read from the health store
        let typesToRead: Set = [
            HKObjectType.workoutType(),
            HKSeriesType.workoutRoute()
        ]
        
        // Request authorization for those quantity types
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            if error != nil {
                completion(error!.localizedDescription)
                return
            }
            completion(nil)
        }
    }
    
    // MARK: - Public Methods
    // Load all workouts and associated data
    public func loadAllWorkouts(completion: @escaping ([Workout]) -> Void) {
        // Load workouts
        self.loadWorkouts { (workouts, error) in
            if error == true || workouts!.isEmpty {
                print("No Workouts Returned by Health Store")
                completion([])
                return
            }
            
            var tally: Int = 0
            var newWorkouts: [Workout] = []
            
            // Load each workout route's data
            for workout in workouts! {
                self.loadWorkoutRoute(workout: workout) { (locations, formattedLocations, error) in
                    tally += 1
                    if error == true {
                        if tally == workouts!.count {
                            completion(newWorkouts)
                        }
                        return
                    }
                    
                    let newWorkoutPolyline = MulticolourPolyline(coordinates: formattedLocations!, count: formattedLocations!.count)
                    switch workout.workoutActivityType {
                    case .running:
                        newWorkoutPolyline.colour = .systemRed
                    case .walking:
                        newWorkoutPolyline.colour = .systemGreen
                    case .cycling:
                        newWorkoutPolyline.colour = .systemBlue
                    default:
                        newWorkoutPolyline.colour = .systemYellow
                    }
                    
                    // Instantiate new workout
                    let newWorkout = Workout(
                        workout: workout,
                        workoutType: workout.workoutActivityType,
                        routeLocations: locations!,
                        routePolylines: [newWorkoutPolyline],
                        date: workout.startDate,
                        distance: workout.totalDistance?.doubleValue(for: HKUnit.meter()),
                        duration: workout.duration,
                        calories: workout.totalEnergyBurned?.doubleValue(for: HKUnit.kilocalorie())
                    )
                    
                    newWorkouts.append(newWorkout)
                    if tally == workouts!.count {
                        completion(newWorkouts)
                    }
                }
            }
        }
    }
    
    // MARK: - Private Methods
    // Load an array of all workouts
    private func loadWorkouts(completion: @escaping ([HKWorkout]?, Bool) -> Void) {
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        // Query the workouts
        let workoutsQuery = HKSampleQuery(sampleType: .workoutType(), predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            guard let workoutSamples = samples as? [HKWorkout] else {
                completion(nil, true)
                return
            }
            // Do something with the array of workouts
            completion(workoutSamples, false)
        }
        healthStore.execute(workoutsQuery)
    }
    
    // Load an array of location data for a specific workout
    private func loadWorkoutRoute(workout: HKWorkout, completion: @escaping ([CLLocation]?, [CLLocationCoordinate2D]?, Bool) -> Void) {
        // Setup predicate for query
        let workoutRouteType = HKSeriesType.workoutRoute()
        let workoutPredicate = HKQuery.predicateForObjects(from: workout)
        
        // Query for workout route
        let workoutRouteQuery = HKSampleQuery(sampleType: workoutRouteType, predicate: workoutPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
            guard let workoutRoutes = samples as? [HKWorkoutRoute] else {
                completion(nil, nil, true)
                return
            }
            if workoutRoutes.isEmpty {
                // No workout route
                completion(nil, nil, true)
                return
            }
            var routeLocations: [CLLocation] = []
            
            // Query for first workout route of workout
            let workoutRouteLocationsQuery = HKWorkoutRouteQuery(route: workoutRoutes.first!) { (routeQuery, locations, done, error) in
                if error != nil {
                    self.healthStore.stop(routeQuery)
                    completion(nil, nil, true)
                    return
                }
                routeLocations.append(contentsOf: locations!)
                
                // If this is the final batch
                if done {
                    if routeLocations.count <= 1 {
                        completion(nil, nil, true)
                    } else {
                        // Format locations
                        let formattedLocations = self.formatLocations(locations: routeLocations)
                        completion(routeLocations, formattedLocations, false)
                    }
                }
            }
            self.healthStore.execute(workoutRouteLocationsQuery)
        }
        healthStore.execute(workoutRouteQuery)
    }
    
    // Format locations from CLLocation to CLLocationCoordinate2D
    private func formatLocations(locations: [CLLocation]) -> [CLLocationCoordinate2D] {
        var formattedLocations: [CLLocationCoordinate2D] = []
        
        for location in locations {
            let newLocation = CLLocationCoordinate2D(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            formattedLocations.append(newLocation)
        }
        return formattedLocations
    }
}
