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
            FindWorkoutPointer()
            FloatingMapButtons(centreCoordinate: $centreCoordinate)
            WorkoutDetailBar()
        }
        .environmentObject(newWorkoutManager)
        .environmentObject(workoutsManager)
        .environmentObject(mapManager)
    }
}
