//
//  WorkoutStatusBar.swift
//  MyMap
//
//  Created by Finnis on 04/03/2021.
//

import SwiftUI

struct WorkoutStatusBar: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var mapManager: MapManager
    
    @State var showWorkoutDetailSheet: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack(spacing: 0) {
                Spacer()
                Text(workoutManager.elapsedSecondsString)
                    .font(.headline)
                Spacer()
                
                if workoutManager.workoutState == .notStarted {
                    StartButton()
                } else {
                    HStack(spacing: 0) {
                        ToggleStateButton()
                        Divider()
                            .frame(height: 62)
                        EndButton()
                    }
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(11)
                }
                
                Spacer()
                Text(workoutManager.totalDistanceString)
                    .font(.headline)
                Spacer()
            }
            .padding(10)
            .background(Blur())
            .compositingGroup()
            .shadow(radius: 2)
            .onTapGesture {
                showWorkoutDetailSheet = true
            }
        }
        .sheet(isPresented: $showWorkoutDetailSheet) {
            WorkoutDetail()
                .environmentObject(workoutManager)
        }
    }
}
