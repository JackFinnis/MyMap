//
//  HealthKitSetupAssistant.swift
//  MyMap
//
//  Created by Finnis on 13/02/2021.
//

import Foundation
import HealthKit

class HealthKitSetupAssistant {
    
    let healthStore = HKHealthStore()
    
    // Request authorization to access HealthKit.
    func requestAuthorisation() {

        // The quantity type to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType(),
            HKSeriesType.workoutRoute()
        ]
        
        // The quantity type to read from the health store.
        let typesToRead: Set = [
            HKQuantityType.workoutType(),
            HKSeriesType.workoutRoute()
        ]
        
        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            // Handle error.
        }
    }
}
