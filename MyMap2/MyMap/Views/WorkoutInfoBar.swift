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
            StartButton()
                .offset(y: 20)
            if workoutsManager.selectedWorkout != nil {
                HStack {
                    Button(action: {
                        workoutsManager.previousWorkout()
                    }, label: {
                        Image(systemName: "arrow.left")
                    })
                    Button(action: {
                        workoutsManager.nextWorkout()
                    }, label: {
                        Image(systemName: "arrow.right")
                    })
                }
                .padding(10)
                .background(Blur())
                .compositingGroup()
                .shadow(radius: 2, y: 2)
                .onTapGesture {
                    showWorkoutDetailSheet = true
                }
            }
        }
        .sheet(isPresented: $showWorkoutDetailSheet) {
            WorkoutDetail()
                .environmentObject(newWorkoutManager)
                .environmentObject(workoutsManager)
        }
    }
}
