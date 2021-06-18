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
                .foregroundColor(Color(UIColor.systemRed))
                .font(.title)
        })
        
        .frame(width: 44, height: 44)
        .padding(3)
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
