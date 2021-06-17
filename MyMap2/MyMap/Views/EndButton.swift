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
                .frame(width: 40, height: 40)
                .padding(3)
        })
        .foregroundColor(Color(UIColor.systemRed))
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
