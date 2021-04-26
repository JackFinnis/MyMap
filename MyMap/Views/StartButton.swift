//
//  StartButton.swift
//  MyMap
//
//  Created by Finnis on 14/02/2021.
//

import SwiftUI
import MapKit
import HealthKit

struct StartButton: View {
    
    @EnvironmentObject var workoutDataStore: WorkoutDataStore
    @EnvironmentObject var workoutManager: WorkoutManager
    
    @Binding var workoutState: WorkoutState
    @Binding var userTrackingMode: MKUserTrackingMode
    
    @State var actionSheetIsPresented: Bool = false
    @State var workoutsSheetIsPresented: Bool = false
    
    var body: some View {
        Button(action: {
            actionSheetIsPresented = true
        }, label: {
            Image(systemName: "record.circle")
                .font(.largeTitle)
                .padding(5)
        })
        .foregroundColor(.white)
        .background(Color(UIColor.systemRed))
        .cornerRadius(.greatestFiniteMagnitude)
        .compositingGroup()
        .shadow(radius: 2, y: 2)
        .actionSheet(isPresented: $actionSheetIsPresented) {
            ActionSheet(
                title: Text("Choose a Workout Type"),
                buttons: [
                    .default(Text("Record Walk")) {
                        recordWorkout(workoutType: .walking)
                    },
                    .default(Text("Record Run")) {
                        recordWorkout(workoutType: .running)
                    },
                    .default(Text("Record Cycle")) {
                        recordWorkout(workoutType: .cycling)
                    },
                    .default(Text("Record Other")) {
                        recordWorkout(workoutType: .other)
                    },
                    .cancel()
                ]
            )
        }
    }
    
    func recordWorkout(workoutType: HKWorkoutActivityType) {
        workoutState = .running
        workoutManager.startWorkout(workoutType: workoutType)
        userTrackingMode = .followWithHeading
    }
}
