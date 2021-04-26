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
    @EnvironmentObject var workoutManager: WorkoutManager
    
    @Binding var mapType: MKMapType
    
    @Binding var workoutsFilter: WorkoutsFilter
    @Binding var workoutsSortBy: WorkoutsSortBy
    
    @State var numberOfworkoutsShown: String = "5"
    let numbersOfWorkoutsShown: [String] = ["None", "5", "10", "All"]
    
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
                
                Section(header: Text("Filter Workouts")) {
                    Picker("Select The Number of Workouts Shown", selection: $numberOfworkoutsShown) {
                        ForEach(numbersOfWorkoutsShown, id: \.self) { number in
                            Text(number)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if workoutsFilter.isShowingWorkouts && !workoutDataStore.finishedLoadingWorkoutRoutes {
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

