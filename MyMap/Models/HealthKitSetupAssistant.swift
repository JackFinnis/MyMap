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
    func requestAuthorization() {

        // The quantity type to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]
        
        // The quantity type to read from the health store.
        let typesToRead: Set = [
            HKQuantityType.workoutType()
        ]
        
        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            // Handle error.
        }
    }
}
