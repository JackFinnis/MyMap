//
//  HealthStore.swift
//  MyMap
//
//  Created by Finnis on 03/02/2021.
//

import Foundation
import HealthKit

class HealthStore {
    
    var healthStore: HKHealthStore?
    
    func requestStepsAuthorisation(completion: @escaping (Bool) -> Void) {
        
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        guard let healthStore = self.healthStore else { return completion(false) }
        
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { (success, error) in
            
            completion(success)
        }
    }
    
    func requestWorkoutAuthorisation(completion: @escaping (Bool) -> Void) {
        
        let stepType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        guard let healthStore = self.healthStore else { return completion(false) }
        
        healthStore.requestAuthorization(toShare: [], read: [stepType]) { (success, error) in
            
            completion(success)
        }
    }
    
    init() {
        
        if HKHealthStore.isHealthDataAvailable() {
            
            healthStore = HKHealthStore()
        }
    }
}
