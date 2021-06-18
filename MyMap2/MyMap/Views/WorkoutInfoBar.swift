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
            ZStack {
                HStack {
                    Button(action: {
                        workoutsManager.previousWorkout()
                    }, label: {
                        Image(systemName: "arrow.left")
                    })
                    .padding(.leading, 10)
                    
                    Text(workoutsManager.selectedWorkoutDurationString)
                        .font(.headline)
                    Spacer()
                    Text(workoutsManager.selectedWorkoutDistanceString)
                        .font(.headline)
                    
                    Button(action: {
                        workoutsManager.nextWorkout()
                    }, label: {
                        Image(systemName: "arrow.right")
                    })
                    .padding(.trailing, 10)
                }
                .buttonStyle(FloatingButtonStyle())
                
                HStack {
                    Spacer()
                    StartButton()
                    Spacer()
                }
            }
            .frame(height: 70)
            .background(Blur())
            .cornerRadius(12)
            .compositingGroup()
            .shadow(radius: 2, y: 2)
            .padding(10)
            .onTapGesture {
                if workoutsManager.selectedWorkout != nil {
                    showWorkoutDetailSheet = true
                }
            }
        }
        .sheet(isPresented: $showWorkoutDetailSheet) {
            WorkoutDetail(workout: workoutsManager.selectedWorkout!, showWorkoutDetailSheet: $showWorkoutDetailSheet)
        }
    }
}
