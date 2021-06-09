//
//  WorkoutView.swift
//  MyMap
//
//  Created by Finnis on 13/02/2021.
//

import SwiftUI

struct WorkoutView: View {
    // Records new workouts
    @StateObject var workoutManager = WorkoutManager()
    // Loads and displays workouts on map
    @StateObject var mapManager = MapManager()
    
    var body: some View {
        ZStack {
            MapView()
                .ignoresSafeArea()
            FloatingMapButtons()
            WorkoutStatusBar()
        }
        .environmentObject(workoutManager)
        .environmentObject(mapManager)
    }
}
