//
//  LoadingView.swift
//  MyMap
//
//  Created by Finnis on 24/04/2021.
//

import SwiftUI

struct LoadingView: View {
    
    // Access workout data store
    @EnvironmentObject var workoutDataStore: WorkoutDataStore
    
    var body: some View {
        VStack {
            Spinner(isAnimating: true)
            Text("Loading Workouts...")
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                print(workoutDataStore.allWorkoutRoutes)
            }
        }
    }
}
