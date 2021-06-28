//
//  WorkoutView.swift
//  MyMap
//
//  Created by Finnis on 13/02/2021.
//

import SwiftUI
import CoreLocation

struct WorkoutView: View {
    // Responsible for recording new workouts
    @StateObject var newWorkoutManager = NewWorkoutManager()
    // Responsible for managing workouts
    @StateObject var workoutsManager = WorkoutsManager()
    // Responsible for map settings
    @StateObject var mapManager = MapManager()
    
    // Map centre coordinate
    @State var centreCoordinate = CLLocationCoordinate2D()
    
    var body: some View {
        ZStack {
            MapView(centreCoordinate: $centreCoordinate)
                .ignoresSafeArea()
            FindWorkoutPointer(centreCoordinate: $centreCoordinate)
            FloatingMapButtons(centreCoordinate: $centreCoordinate)
            
            // Workout detail bar
            if newWorkoutManager.workoutState != .notStarted {
                NewWorkoutInfoBar()
            } else {
                WorkoutInfoBar()
            }
        }
        .environmentObject(newWorkoutManager)
        .environmentObject(workoutsManager)
        .environmentObject(mapManager)
        .preferredColorScheme(mapManager.mapType == .standard ? .none : .dark)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.mapManager.userTrackingMode = .follow
            }
        }
    }
}
