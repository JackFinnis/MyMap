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
    var allWorkoutRoutes: [[CLLocation]]!
    
    init() {
        // Load all workout routes
        loadAllWorkoutRoutes()
    }
    
    // Load all workout routes into array
    func loadAllWorkoutRoutes() {
        
        let allWorkouts = loadWorkouts()
        
        // Check if no workouts were returned
        guard allWorkouts != nil else {
            return
        }
        
        // Load each workout route's data
        for workout in allWorkouts! {
            // Add each route to the routes array
            let workoutRoute = loadWorkoutRoute(workout: workout)
            
            // Check if route is empty
            guard workoutRoute != nil else {
                return
            }
            
            allWorkoutRoutes.append(workoutRoute!)
        }
    }
    
    // Load an array of all the workouts of a given type
    func loadWorkouts() -> [HKWorkout]? {
        
        var workoutSamples: [HKWorkout]?
        
        // Setup predicate for query
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .cycling)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        
        // Query for workouts
        let workoutsQuery = HKSampleQuery(sampleType: .workoutType(), predicate: workoutPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { (query, samples, error) in

            print(samples)
            
            // Do something with the array of workouts
            workoutSamples = samples as? [HKWorkout]
        }
        // Execute the workout query
        healthStore.execute(workoutsQuery)
        
        print("Workouts list: \(workoutSamples)")
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
            
            // Do something with the array of workout routes
            let workoutRoutes = samples as? [HKWorkoutRoute]
            print("Workout Routes: \(workoutRoutes)")
            
            for workoutRoute in workoutRoutes! {
                
                print("Workout Route: \(workoutRoute)")
                // Query for each workout route's location data
                let workoutRouteLocationsQuery = HKWorkoutRouteQuery(route: workoutRoute) { (routeQuery, locations, done, error) in
                    
                    // Do something with the array of location data
                    routeLocations?.append(contentsOf: locations!)
                }
                // Execute the workout route locations query
                self.healthStore.execute(workoutRouteLocationsQuery)
            }
        }
        // Execute the workout route query
        healthStore.execute(workoutRouteQuery)
        
        return routeLocations
    }
}
