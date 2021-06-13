//
//  FilterWorkouts.swift
//  MyMap
//
//  Created by Finnis on 25/04/2021.
//

import SwiftUI

struct FilterWorkouts: View {
    @EnvironmentObject var workoutsManager: WorkoutsManager
    @EnvironmentObject var mapManager: MapManager
    
    @Binding var showFilterWorkoutsSheet: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Workout Source")) {
                    Toggle("Local", isOn: $workoutsManager.showHealthKitWorkouts.animation())
                    if !workoutsManager.finishedLoading {
                        HStack {
                            Spinner()
                            Text("Loading Local Workouts...")
                                .font(.subheadline)
                        }
                    }
                    Toggle("Strava", isOn: $workoutsManager.showStravaWorkouts.animation())
                }
                Section(header: Text("Workouts Shown")) {
                    Picker("Number of Workouts Shown", selection: $workoutsManager.numberShown.animation()) {
                        ForEach(WorkoutsShown.allCases, id: \.self) { number in
                            Text(number.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if workoutsManager.numberShown != .none {
                        Picker("Sort By", selection: $workoutsManager.sortBy) {
                            ForEach(WorkoutsSortBy.allCases, id: \.self) { sortBy in
                                Text(sortBy.rawValue)
                            }
                        }
                    }
                }
                
                AdvancedFilters()
            }
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        showFilterWorkoutsSheet = false
                    }, label: {
                        Text("Done")
                    })
                }
            }
        }
    }
}

