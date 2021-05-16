//
//  WorkoutsFilter.swift
//  MyMap
//
//  Created by Finnis on 26/04/2021.
//

import Foundation

enum WorkoutsShown: String, CaseIterable {
    case none = "None";
    case five = "5";
    case ten = "10";
    case all = "All";
}

enum WorkoutsSortBy: String, CaseIterable {
    case startDate = "Start Date";
    case endDate = "End Date";
    
    case shortestDistance = "Shortest Distance";
    case longestDistance = "Longest Distance";
    
    case shortestDuration = "Shortest Duration";
    case longestDuration = "Longest Duration";
}

class WorkoutsFilter: ObservableObject {
    
    @Published var numberShown: WorkoutsShown = .none
    var isShowingWorkouts: Bool {
        if numberShown != .none {
            return true
        } else {
            return false
        }
    }
    @Published var sortBy: WorkoutsSortBy = .endDate
    
    @Published var filterByType: Bool = false
    @Published var displayWalks: Bool = true
    @Published var displayRuns: Bool = true
    @Published var displayCycles: Bool = true
    @Published var displayOther: Bool = true
    
    @Published var filterByDistance: Bool = false
    @Published var minimumDistance: Double = 0
    @Published var maximumDistance: Double = 0
    
    @Published var filterByDuration: Bool = false
    @Published var minimumDuration: Double = 0
    @Published var maximumDuration: Double = 0
    
    @Published var filterByDate: Bool = false
    @Published var startDate = Date()
    @Published var endDate = Date()
    
    @Published var filterByCalories: Bool = false
    @Published var minimumCalories: Double = 0
    @Published var maximumCalories: Double = 0
    
    @Published var filterByElevation: Bool = false
    @Published var minimumElevation: Double = 0
    @Published var maximumElevation: Double = 0
}
