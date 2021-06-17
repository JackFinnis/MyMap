//
//  WorkoutInfoBar.swift
//  MyMap
//
//  Created by Finnis on 13/06/2021.
//

import SwiftUI

struct WorkoutInfoBar: View {
    @EnvironmentObject var newWorkoutManager: NewWorkoutManager
    @EnvironmentObject var workoutsManager: WorkoutsManager
    @EnvironmentObject var mapManager: MapManager
    
    @State var showWorkoutDetailSheet: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Button(action: {
                    workoutsManager.previousWorkout()
                }, label: {
                    Image(systemName: "arrow.left")
                })
                .buttonStyle(FloatingButtonStyle())
                
                Spacer()
                Text(workoutsManager.selectedWorkoutDurationString)
                    .font(.headline)
                Spacer()
                
                StartButton()
                
                Spacer()
                Text(workoutsManager.selectedWorkoutDistanceString)
                    .font(.headline)
                Spacer()
                
                Button(action: {
                    workoutsManager.nextWorkout()
                }, label: {
                    Image(systemName: "arrow.right")
                })
                .buttonStyle(FloatingButtonStyle())
            }
            .frame(height: 60)
            .background(Blur())
            .cornerRadius(12)
            .compositingGroup()
            .shadow(radius: 2, y: 2)
            .padding(10)
            .onTapGesture {
                showWorkoutDetailSheet = true
            }
        }
        .sheet(isPresented: $showWorkoutDetailSheet) {
            WorkoutDetail()
                .environmentObject(newWorkoutManager)
                .environmentObject(workoutsManager)
        }
    }
}
