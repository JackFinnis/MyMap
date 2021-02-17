//
//  StartButton.swift
//  MyMap
//
//  Created by Finnis on 14/02/2021.
//

import SwiftUI

struct StartButton: View {
    
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        
        Button(action: {
            // Start workout
            workoutManager.startWorkout()
        }, label: {
            HStack {
                Text("Start")
                Image(systemName: "play.fill")
            }
            .padding()
            .foregroundColor(Color(UIColor.white))
            .background(Color(UIColor.systemGreen))
        })
        .cornerRadius(20)
    }
}
