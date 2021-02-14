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
            workoutManager.state = .running
        }, label: {
            HStack {
                Text("Start")
                Image(systemName: "play.fill")
            }
            .padding()
            .foregroundColor(.white)
            .background(Color.green)
        })
        .cornerRadius(20)
    }
}
