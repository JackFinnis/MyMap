//
//  WorkoutsFilter.swift
//  MyMap
//
//  Created by Finnis on 26/04/2021.
//

import Foundation

class WorkoutsFilter: ObservableObject {
    @Published var sortBy: WorkoutsSortBy = .endDate
    @Published var numberShown: WorkoutsShown = .none
    var showWorkouts: Bool {
        if numberShown == .none {
            return false
        } else {
            return true
        }
    }
    
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
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    
    @Published var filterByCalories: Bool = false
    @Published var minimumCalories: Double = 0
    @Published var maximumCalories: Double = 0
    
    @Published var filterByElevation: Bool = false
    @Published var minimumElevation: Double = 0
    @Published var maximumElevation: Double = 0
}
