//
//  WorkoutDataStore.swift
//  MyMap
//
//  Created by Finnis on 13/02/2021.
//

import Foundation
import HealthKit
import CoreLocation

class WorkoutDataStore {
    
    let healthStore = HKHealthStore()
    
    // Load an array of all the workouts of a given type
    func loadWorkouts() -> [HKWorkout]? {
        
        var workoutSamples: [HKWorkout]?
        
        // Setup predicate for query
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .walking)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        
        // Query for workouts
        let workoutsQuery = HKSampleQuery(sampleType: .workoutType(), predicate: workoutPredicate, limit: 0, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            
            DispatchQueue.main.async {
                // Do something with the array of workouts
                workoutSamples = samples as? [HKWorkout]
            }
        }
        // Execute the workout query
        healthStore.execute(workoutsQuery)
        
        return workoutSamples
    }
    
    // Load an array of location data for a specific workout
    func loadWorkoutRoute(workout: HKWorkout) -> [CLLocation]? {
        
        var routeLocations: [CLLocation]?
        
        // Setup predicate for query
        let workoutRouteType = HKSeriesType.workoutRoute()
        let workoutPredicate = HKQuery.predicateForObjects(from: workout)
        
        // Query for workout route
        let workoutRouteQuery = HKSampleQuery(sampleType: workoutRouteType, predicate: workoutPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
            
            DispatchQueue.main.async {
                // Do something with the array of workout routes
                let workoutRoutes = samples as? [HKWorkoutRoute]
                
                for workoutRoute in workoutRoutes! {
                    
                    // Query for each workout route's location data
                    let workoutRouteLocationsQuery = HKWorkoutRouteQuery(route: workoutRoute) { (routeQuery, locations, done, error) in
                        
                        // Do something with the array of location data
                        let workoutRouteLocations = locations as? [CLLocation]
                        
                        routeLocations?.append(contentsOf: workoutRouteLocations!)
                    }
                    // Execute the workout route locations query
                    self.healthStore.execute(workoutRouteLocationsQuery)
                }
            }
        }
        // Execute the workout route query
        healthStore.execute(workoutRouteQuery)
        
        return routeLocations
    }
}
