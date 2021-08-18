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
    @EnvironmentObject var newWorkoutManager: NewWorkoutManager
    @EnvironmentObject var mapManager: MapManager
    
    @State var showActionSheet: Bool = false
    
    var body: some View {
        Button(action: {
            showActionSheet = true
        }, label: {
            Image(systemName: "record.circle")
                .font(.largeTitle)
                .padding(5)
        })
        .foregroundColor(.white)
        .background(Color(UIColor.systemRed))
        .clipShape(Circle())
        .compositingGroup()
        .shadow(color: Color(UIColor.systemFill), radius: 5)
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("Record a Workout"),
                buttons: [
                    .default(Text("Walk")) {
                        recordWorkout(workoutType: .walking)
                    },
                    .default(Text("Run")) {
                        recordWorkout(workoutType: .running)
                    },
                    .default(Text("Cycle")) {
                        recordWorkout(workoutType: .cycling)
                    },
                    .default(Text("Other")) {
                        recordWorkout(workoutType: .other)
                    },
                    .cancel()
                ]
            )
        }
        .alert(isPresented: $newWorkoutManager.showAlert) {
            Alert(
                title: Text("Recording Failed"),
                message: Text("MyMap needs access to your workout routes to show them on the map. Allow access in the Health App. MyMap needs access to your location to record workout routes. Allow access in the Settings App."),
                dismissButton: .cancel(Text("Ok"))
            )
        }
    }
    
    func recordWorkout(workoutType: HKWorkoutActivityType) {
        newWorkoutManager.startWorkout(workoutType: workoutType)
        if newWorkoutManager.workoutState == .running {
            mapManager.userTrackingMode = .followWithHeading
        }
    }
}
