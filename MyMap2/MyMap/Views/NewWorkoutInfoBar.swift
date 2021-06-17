//
//  NewWorkoutInfoBar.swift
//  MyMap
//
//  Created by Finnis on 04/03/2021.
//

import SwiftUI

struct NewWorkoutInfoBar: View {
    @EnvironmentObject var newWorkoutManager: NewWorkoutManager
    @EnvironmentObject var workoutsManager: WorkoutsManager
    @EnvironmentObject var mapManager: MapManager
    
    @State var showWorkoutDetailSheet: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack(spacing: 0) {
                Spacer()
                Text(newWorkoutManager.elapsedSecondsString)
                    .font(.headline)
                Spacer()
                
                HStack(spacing: 0) {
                    ToggleStateButton()
                    Divider()
                        .frame(height: 60)
                    EndButton()
                }
                .background(Color(UIColor.systemBackground))
                .cornerRadius(12)
                
                Spacer()
                Text(newWorkoutManager.totalDistanceString)
                    .font(.headline)
                Spacer()
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
