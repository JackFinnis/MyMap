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
    var allWorkouts: [HKWorkout]?
    
    init() {
        // Load all workout routes
        loadAllWorkoutRoutes()
    }
    
    // Load all workout routes into array
    func loadAllWorkoutRoutes() {
        
        // Load array of workouts from health store
        loadWorkouts()
        
        print(allWorkouts)
        
        // Case no workouts were returned
        guard allWorkouts != nil else {
            print("No Workouts Returned by Health Store")
            return
        }
        
        // Load each workout route's data
        for workout in allWorkouts! {
            // Add each route to the routes array
            let workoutRoute = loadWorkoutRoute(workout: workout)
            
            // Case route is empty
            guard workoutRoute != nil else {
                return
            }
            
            allWorkoutRoutes.append(workoutRoute!)
        }
    }
    
    // Load an array of all the workouts of a given type
    func loadWorkouts() {
        
        // Setup predicate for query
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .cycling)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        
        // Query for workouts
        let workoutsQuery = HKSampleQuery(sampleType: .workoutType(), predicate: workoutPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            
            print("Type of workouts query: \(type(of: samples))")
            
            DispatchQueue.main.async {
                // Do something with the array of workouts
                self.allWorkouts = samples as? [HKWorkout]
            }
        }
        // Execute the workout query
        healthStore.execute(workoutsQuery)
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
            
            // Case no workout routes loaded
            guard workoutRoutes != nil else {
                print("No workout routes loaded")
                return
            }
            
            for workoutRoute in workoutRoutes! {
                
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
