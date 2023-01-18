//
//  WorkoutInfoBar.swift
//  MyMap
//
//  Created by Finnis on 13/06/2021.
//

import SwiftUI

struct WorkoutBar: View {
    @State var showWorkoutView = false
    
    let workout: Workout
    
    var body: some View {
        Button {
            showWorkoutView = false
        } label: {
            Row {
                Text(workout.seconds.formatted())
            } trailing: {
                Text(workout.metres?.formatted() ?? "")
            }
        }
        .buttonStyle(.plain)
        .font(.headline)
        .materialBackground()
        .sheet(isPresented: $showWorkoutView) {
            WorkoutView(workout: workout)
        }
    }
}
