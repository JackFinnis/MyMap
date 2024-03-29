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
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 24))
                            .frame(width: 48, height: 48)
                    })
                    
                    Text(workoutsManager.selectedWorkoutDurationString)
                        .font(.headline)
                    Spacer()
                    Text(workoutsManager.selectedWorkoutDistanceString)
                        .font(.headline)
                    
                    Button(action: {
                        workoutsManager.nextWorkout()
                    }, label: {
                        Image(systemName: "chevron.forward")
                            .font(.system(size: 24))
                            .frame(width: 48, height: 48)
                    })
                }
                
                HStack {
                    Spacer()
                    StartButton()
                    Spacer()
                }
            }
            .frame(height: 70)
            .background(Blur())
            .cornerRadius(10)
            .compositingGroup()
            .shadow(color: Color(UIColor.systemFill), radius: 5)
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
