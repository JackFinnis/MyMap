//
//  WorkoutView.swift
//  MyMap
//
//  Created by Finnis on 13/02/2021.
//

import SwiftUI

struct WorkoutView: View {
    // Responsible for recording new workouts
    @StateObject var newWorkoutManager = NewWorkoutManager()
    // Responsible for managing workouts
    @StateObject var workoutsManager = WorkoutsManager()
    // Responsible for map settings
    @StateObject var mapManager = MapManager()
    
    var body: some View {
        ZStack {
            MapView()
                .ignoresSafeArea()
            FloatingMapButtons()
            WorkoutStatusBar()
        }
        .environmentObject(newWorkoutManager)
        .environmentObject(workoutsManager)
        .environmentObject(mapManager)
    }
}
