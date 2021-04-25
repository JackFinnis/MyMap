//
//  MapSettings.swift
//  MyMap
//
//  Created by Finnis on 25/04/2021.
//

import SwiftUI
import MapKit

struct MapSettings: View {
    
    @EnvironmentObject var workoutDataStore: WorkoutDataStore
    
    @Binding var mapType: MKMapType
    @Binding var showAllWorkouts: Bool
    
    let mapTypeNames: [String] = ["Standard", "Satellite", "Hybrid"]
    let mapTypes: [MKMapType] = [.standard, .satellite, .hybrid]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Map Type")) {
                    Picker("Select a Map Type", selection: $mapType) {
                        ForEach(mapTypes, id: \.self) { type in
                            Text(mapTypeNames[mapTypes.firstIndex(of: type)!])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Workouts")) {
                    Toggle(isOn: $showAllWorkouts, label: {
                        Text("Show Workout Routes")
                    })
                    if showAllWorkouts && !workoutDataStore.finishedLoadingWorkoutRoutes {
                        HStack {
                            Spinner()
                            Text("Loading Workouts...")
                        }
                    }
                }
            }
            .navigationTitle("Map Settings")
        }
    }
}

