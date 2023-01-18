//
//  EndButton.swift
//  MyMap
//
//  Created by Finnis on 14/02/2021.
//

import SwiftUI

struct EndButton: View {
    @EnvironmentObject var newWorkoutManager: NewWorkoutManager
    
    @State var showEndWorkoutAlert: Bool = false
    
    var body: some View {
        Button(action: {
            showEndWorkoutAlert = true
        }, label: {
            Image(systemName: "stop.fill")
                .font(.title)
                .frame(width: 48, height: 48)
                .foregroundColor(.red)
        })
        .alert(isPresented: $showEndWorkoutAlert) {
            Alert(
                title: Text("Finish Workout?"),
                primaryButton: .default(Text("Confirm")) {
                    newWorkoutManager.endWorkout()
                },
                secondaryButton: .cancel()
            )
        }
    }
}
