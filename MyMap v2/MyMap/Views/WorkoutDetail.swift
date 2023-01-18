//
//  WorkoutDetail.swift
//  MyMap
//
//  Created by Finnis on 25/04/2021.
//

import SwiftUI

struct WorkoutDetail: View {
    var workout: Workout
    
    @Binding var showWorkoutDetailSheet: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    HStack {
                        Text("Type")
                        Spacer()
                        Text(workout.workoutTypeString)
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Date")
                        Spacer()
                        Text(workout.dateString)
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Distance")
                        Spacer()
                        Text(workout.distanceString)
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Duration")
                        Spacer()
                        Text(workout.durationString)
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Calories")
                        Spacer()
                        Text(workout.caloriesString)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Workout Details")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        showWorkoutDetailSheet = false
                    }, label: {
                        Text("Done")
                    })
                }
            }
        }
    }
}
