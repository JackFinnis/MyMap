//
//  WorkoutDataStore.swift
//  MyMap
//
//  Created by Finnis on 13/02/2021.
//

import Foundation
import HealthKit
import CoreLocation

class WorkoutDataStore: ObservableObject {
    
    let healthStore = HKHealthStore()
    
    // All workout routes
    @Published var allWorkoutRoutes: [[CLLocation]] = []
    
    // Load all workout routes into array
    public func loadAllWorkoutRoutes() {

        // Load array of workouts from health store
        loadWorkouts { (workouts, error) in
            if error != nil {
                print("No Workouts Returned by Health Store")
                return
            }
            
            for workout in workouts! {
                // Load each workout route's data
                self.loadWorkoutRoute(workout: workout) { (workoutRouteLocations, error) in
                    if error != nil {
                        print("Workout has no routes")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.allWorkoutRoutes.append(workoutRouteLocations!)
                    }
                }
            }
        }
    }
    
    // Load an array of all workouts
    func loadWorkouts(completion: @escaping ([HKWorkout]?, Error?) -> Void) {
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        
        // Query the workouts
        let workoutsQuery = HKSampleQuery(sampleType: .workoutType(), predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            
            // Do something with the array of workouts
            guard let workoutSamples = samples as? [HKWorkout], error == nil
            else {
                completion(nil, error)
                return
            }
            
            completion(workoutSamples, nil)
        }
        healthStore.execute(workoutsQuery)
    }
    
    // Load an array of workout routes
    
    // Load an array of location data for a specific workout
    func loadWorkoutRoute(workout: HKWorkout, completion: @escaping ([CLLocation]?, Error?) -> Void) {
        // Setup predicate for query
        let workoutRouteType = HKSeriesType.workoutRoute()
        let workoutPredicate = HKQuery.predicateForObjects(from: workout)
        
        // Query for workout route
        let workoutRouteQuery = HKSampleQuery(sampleType: workoutRouteType, predicate: workoutPredicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
        
            // Do something with the array of workout routes
            guard let workoutRoutes = samples as? [HKWorkoutRoute], error == nil
            else {
                completion(nil, error)
                return
            }
            
            if workoutRoutes.count > 0 {
                // Query for first workout route of workout
                let workoutRouteLocationsQuery = HKWorkoutRouteQuery(route: workoutRoutes.first!) { (routeQuery, locations, done, error) in
                    
                    // Do something with the array of location data
                    if error != nil {
                        // Error in retrieving route locations
                        completion(nil, error)
                        return
                    }
                    
                    // Do something with the array of location data
                    completion(locations, nil)
                }
                self.healthStore.execute(workoutRouteLocationsQuery)
            }
        }
        healthStore.execute(workoutRouteQuery)
    }
}
