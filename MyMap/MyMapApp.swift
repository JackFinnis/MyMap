//
//  MyMapApp.swift
//  MyMap
//
//  Created by Finnis on 27/01/2021.
//

import SwiftUI

@main
struct MyMapApp: App {
    
    // Access workout manager business logic
    @ObservedObject var workoutManager = WorkoutManager()
    
    // Access heath store data
    @ObservedObject var workoutDataStore = WorkoutDataStore()
    
    // Workout filters and sorts
    @ObservedObject var workoutsFilter = WorkoutsFilter()
    @ObservedObject var workoutsSortBy = WorkoutsSortBy()
    
    var body: some Scene {
        WindowGroup {
            WorkoutView()
                .environmentObject(workoutManager)
                .environmentObject(workoutDataStore)
                .environmentObject(workoutsFilter)
                .environmentObject(workoutsSortBy)
        }
    }
}
