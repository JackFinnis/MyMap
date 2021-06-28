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
                HStack(spacing: 0) {
                    Button(action: {
                        workoutsManager.previousWorkout()
                    }, label: {
                        Image(systemName: "arrow.left")
                    })
                    .padding(.leading, 5)
                    
                    Text(workoutsManager.selectedWorkoutDurationString)
                        .font(.headline)
                        .padding(.leading, 5)
                    Spacer()
                    Text(workoutsManager.selectedWorkoutDistanceString)
                        .font(.headline)
                        .padding(.trailing, 5)
                    
                    Button(action: {
                        workoutsManager.nextWorkout()
                    }, label: {
                        Image(systemName: "arrow.right")
                    })
                    .padding(.trailing, 5)
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
                .preferredColorScheme(mapManager.mapType == .standard ? .none : .dark)
        }
    }
}
