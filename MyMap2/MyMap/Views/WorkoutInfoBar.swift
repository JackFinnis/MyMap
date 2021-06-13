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
                if workoutsManager.selectedWorkout != nil {
                    Button(action: {
                        workoutsManager.previousWorkout()
                    }, label: {
                        Image(systemName: "arrow.left")
                    })
                }
                Spacer()
                StartButton()
                Spacer()
                if workoutsManager.selectedWorkout != nil {
                    Button(action: {
                        workoutsManager.nextWorkout()
                    }, label: {
                        Image(systemName: "arrow.right")
                    })
                }
            }
            .buttonStyle(FloatingButtonStyle())
            .frame(height: 40)
            .background(Blur())
            .padding(10)
            .cornerRadius(20)
            .compositingGroup()
            .shadow(radius: 2, y: 2)
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
