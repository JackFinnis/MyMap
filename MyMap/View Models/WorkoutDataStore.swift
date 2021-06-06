//
//  WorkoutDataStore.swift
//  MyMap
//
//  Created by Finnis on 13/02/2021.
//

import Foundation
import HealthKit
import CoreLocation
import MapKit

class WorkoutDataStore: ObservableObject {
    // MARK: - Properties
    @Published var finishedLoading: Bool = false
    @Published var workouts: [Workout] = []
    
    let healthStore = HKHealthStore()
    
    // MARK: - Public functions
    // Load all workout routes into array
    public func loadWorkoutsData() {
        // Load array of workouts from health store
        loadWorkouts { (workouts, error) in
            if error == true {
                print("No Workouts Returned by Health Store")
                return
            }
            // Load each workout route's data
            for workout in workouts! {
                self.loadWorkoutRoute(workout: workout) { (locations, formattedLocations, error) in
                    if error == true {
                        // Workout has no route
                        return
                    }
                    // Instantiate new workout
                    let newWorkout = Workout(
                        workout: workout,
                        workoutType: workout.workoutActivityType,
                        routeLocations: locations!,
                        routePolylines: [MKPolyline(coordinates: formattedLocations!, count: formattedLocations!.count)],
                        date: workout.startDate,
                        distance: workout.totalDistance?.doubleValue(for: HKUnit.meter()),
                        duration: workout.duration,
                        elevation: 0,
                        calories: workout.totalEnergyBurned?.doubleValue(for: HKUnit.smallCalorie())
                    )
                    
                    // Update published properties
                    DispatchQueue.main.async {
                        self.workouts.append(newWorkout)
                        if workout == workouts!.last {
                            self.finishedLoading = true
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Private functions
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
            if workoutRoutes.count == 0 {
                // No workout route
                completion(nil, nil, true)
                return
            }
            
            // Do something with the workout route
            var routeLocations: [CLLocation] = []
            
            // Query for first workout route of workout
            let workoutRouteLocationsQuery = HKWorkoutRouteQuery(route: workoutRoutes.first!) { (routeQuery, locations, done, error) in
                if error != nil {
                    self.healthStore.stop(routeQuery)
                    completion(nil, nil, true)
                    return
                }
                // Do something with this batch of location data
                routeLocations.append(contentsOf: locations!)
                
                // If this is the final batch
                if done {
                    // Format locations
                    var formattedLocations: [CLLocationCoordinate2D] = []
                    for location in routeLocations {
                        let newLocation = CLLocationCoordinate2D(
                            latitude: location.coordinate.latitude,
                            longitude: location.coordinate.longitude
                        )
                        formattedLocations.append(newLocation)
                    }
                    completion(routeLocations, formattedLocations, false)
                }
            }
            self.healthStore.execute(workoutRouteLocationsQuery)
        }
        healthStore.execute(workoutRouteQuery)
    }
}
