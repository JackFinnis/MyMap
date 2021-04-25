//
//  EndButton.swift
//  MyMap
//
//  Created by Finnis on 14/02/2021.
//

import SwiftUI

struct EndButton: View {
    
    @EnvironmentObject var workoutManager: WorkoutManager
    
    @Binding var workoutState: WorkoutState
    
    @State var showingAlert: Bool = false
    
    var body: some View {
        Button(action: {
            showingAlert = true
        }, label: {
            Image(systemName: "stop.fill")
                .font(.title)
                .padding(10)
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
