//
//  WorkoutStatusBar.swift
//  MyMap
//
//  Created by Finnis on 04/03/2021.
//

import SwiftUI
import MapKit

struct WorkoutStatusBar: View {
    @EnvironmentObject var workoutDataStore: WorkoutDataStore
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var workoutsFilter: WorkoutsFilter
    @EnvironmentObject var mapManager: MapManager
    
    @State var showWorkoutDetailSheet: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(workoutManager.elapsedSecondsString)
                    .font(.headline)
                Spacer()
                
                if workoutManager.workoutState == .notStarted {
                    StartButton()
                } else {
                    HStack {
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
            .buttonStyle(PlainButtonStyle())
            .onTapGesture {
                showWorkoutDetailSheet = true
            }
        }
        .sheet(isPresented: $showWorkoutDetailSheet) {
            WorkoutDetail()
        }
    }
}
