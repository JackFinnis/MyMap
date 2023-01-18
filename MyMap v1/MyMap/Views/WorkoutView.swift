//
//  WorkoutView.swift
//  MyMap
//
//  Created by Finnis on 13/02/2021.
//

import SwiftUI

struct WorkoutView: View {
    // Responsible for recording new workouts
    @StateObject var workoutManager = WorkoutManager()
    // Responsible for displaying workouts on map
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
