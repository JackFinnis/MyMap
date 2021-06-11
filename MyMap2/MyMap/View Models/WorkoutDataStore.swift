//
//  WorkoutDataStore.swift
//  MyMap
//
//  Created by Finnis on 09/06/2021.
//

import Foundation
import HealthKit
import CoreLocation

class WorkoutDataStore {
    // MARK: - Properties
    private let healthStore = HKHealthStore()
    
    // MARK: - Public Methods
    // Load an array of all workouts
    public func loadWorkouts(completion: @escaping ([HKWorkout]?, Bool) -> Void) {
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
    public func loadWorkoutRoute(workout: HKWorkout, completion: @escaping ([CLLocation]?, [CLLocationCoordinate2D]?, Bool) -> Void) {
        // Setup predicate for query
        let workoutRouteType = HKSeriesType.workoutRoute()
        let workoutPredicate = HKQuery.predicateForObjects(from: workout)
        
        // Query for workout route
        let workoutRouteQuery = HKSampleQuery(sampleType: workoutRouteType, predicate: workoutPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
            guard let workoutRoutes = samples as? [HKWorkoutRoute] else {
                completion(nil, nil, true)
                return
            }
            if workoutRoutes.count == 0 {
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
                    // Format locations
                    let formattedLocations = self.formatLocations(locations: routeLocations)
                    completion(routeLocations, formattedLocations, false)
                }
            }
            self.healthStore.execute(workoutRouteLocationsQuery)
        }
        healthStore.execute(workoutRouteQuery)
    }
    
    // MARK: - Private Helper Methods
    // Format locations from CLLocation to CLLocationCoordinate2D
    func formatLocations(locations: [CLLocation]) -> [CLLocationCoordinate2D] {
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
