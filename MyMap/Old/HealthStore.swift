//
//  HealthStore.swift
//  MyMap
//
//  Created by Finnis on 03/02/2021.
//

/*

import Foundation
import HealthKit
import CoreLocation

class HealthStore {
    
    var healthStore: HKHealthStore?
    
    func requestStepsAuthorisation(completion: @escaping (Bool) -> Void) {
        
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        guard let healthStore = self.healthStore else { return completion(false) }
        
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { (success, error) in
            
            completion(success)
        }
    }
    
    func getRouteData() {
        
        let runningObjectQuery = HKQuery.predicateForObjects(from: myWorkout)

        let routeQuery = HKAnchoredObjectQuery(type: HKSeriesType.workoutRoute(), predicate: runningObjectQuery, anchor: nil, limit: HKObjectQueryNoLimit) { (query, samples, deletedObjects, anchor, error) in
            
            guard error == nil else {
                // Handle any errors here.
                fatalError("The initial query failed.")
            }
            
            // Process the initial route data here.
        }

        routeQuery.updateHandler = { (query, samples, deleted, anchor, error) in
            
            guard error == nil else {
                // Handle any errors here.
                fatalError("The update failed.")
            }
            
            // Process updates or additions here.
        }

        healthStore.execute(routeQuery)
        
        // Create the route query.
        let query = HKWorkoutRouteQuery(route: myRoute) { (query, locationsOrNil, done, errorOrNil) in
            
            // This block may be called multiple times.
            
            if let error = errorOrNil {
                // Handle any errors here.
                return
            }
            
            guard let locations = locationsOrNil else {
                fatalError("*** Invalid State: This can only fail if there was an error. ***")
            }
            
            // Do something with this batch of location data.
                
            if done {
                // The query returned all the location data associated with the route.
                // Do something with the complete data set.
            }
            
            // You can stop the query by calling:
            // store.stop(query)
            
        }
        healthStore.execute(query)
    }
    
    init() {
        
        if HKHealthStore.isHealthDataAvailable() {
            
            healthStore = HKHealthStore()
        }
    }
}

 */
