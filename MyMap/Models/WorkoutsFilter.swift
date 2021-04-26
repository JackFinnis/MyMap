//
//  WorkoutsFilter.swift
//  MyMap
//
//  Created by Finnis on 26/04/2021.
//

import Foundation

enum workoutsShown: String, CaseIterable {
    case none = "None";
    case five = "5";
    case ten = "10";
    case all = "All"
}

enum workoutType: String, CaseIterable {
    case walking = "Walking";
    case running = "Running";
    case cycling = "Cycling";
    case other = "Other";
    case all = "All"
}

class WorkoutsFilter {
    var numberShown: workoutsShown = .five
    var type: workoutType = .all
    
    var startDate: Date?
    var endDate: Date?
    
    var minimumDuration: Double?
    var maximumDuration: Double?
    
    var minimumDistance: Double?
    var maximumDistance: Double?
    
    var minimumCalories: Double?
    var maximumCalories: Double?
    
    var minimumElevation: Double?
    var maximumElevation: Double?
    
    var isShowingWorkouts: Bool {
        if numberShown == .none {
            return false
        } else {
            return true
        }
    }
}
