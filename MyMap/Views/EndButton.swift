//
//  EndButton.swift
//  MyMap
//
//  Created by Finnis on 14/02/2021.
//

import SwiftUI

struct EndButton: View {
    
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        
        Button(action: {
            // End workout
            workoutManager.endWorkout()
        }, label: {
            HStack {
                Text("End")
                Image(systemName: "stop.fill")
            }
            .padding()
            .foregroundColor(Color(UIColor.white))
            .background(Color(UIColor.systemRed))
        })
        .cornerRadius(20)
    }
}
