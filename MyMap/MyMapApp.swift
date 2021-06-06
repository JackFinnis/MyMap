//
//  MyMapApp.swift
//  MyMap
//
//  Created by Finnis on 27/01/2021.
//

import SwiftUI

@main
struct MyMapApp: App {
    
    // Workout manager business logic
    @StateObject var workoutManager = WorkoutManager()
    
    // Heath store data
    @StateObject var workoutDataStore = WorkoutDataStore()
    
    // Workout filters
    @StateObject var workoutsFilter = WorkoutsFilter()
    
    var body: some Scene {
        WindowGroup {
            WorkoutView()
                .environmentObject(workoutManager)
                .environmentObject(workoutDataStore)
                .environmentObject(workoutsFilter)
        }
    }
}
