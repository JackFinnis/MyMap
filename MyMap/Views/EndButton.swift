//
//  EndButton.swift
//  MyMap
//
//  Created by Finnis on 14/02/2021.
//

import SwiftUI

struct EndButton: View {
    
    @EnvironmentObject var workoutDataStore: WorkoutDataStore
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var workoutsFilter: WorkoutsFilter
    @EnvironmentObject var workoutsSortBy: WorkoutsSortBy
    
    @Binding var workoutState: WorkoutState
    
    @State var showingAlert: Bool = false
    
    var body: some View {
        Button(action: {
            showingAlert = true
        }, label: {
            Image(systemName: "stop.fill")
                .font(.title)
                .padding(.vertical, 15)
                .padding(.leading, 10)
                .padding(.trailing, 15)
        })
        .foregroundColor(Color(UIColor.systemRed))
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Finish Workout?"),
                primaryButton: .default(Text("Confirm")) {
                    // End workout
                    workoutState = .notStarted
                    workoutManager.endWorkout()
                },
                secondaryButton: .cancel()
            )
        }
    }
}
