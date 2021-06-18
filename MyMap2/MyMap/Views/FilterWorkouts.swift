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
                Section(header: Text("Workouts Shown")) {
                    Picker("Number of Workouts Shown", selection: $workoutsManager.numberShown.animation()) {
                        ForEach(WorkoutsShown.allCases, id: \.self) { number in
                            Text(getNumberString(numberString: number.rawValue))
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if workoutsManager.numberShown != .none {
                        if !workoutsManager.finishedLoading {
                            HStack {
                                Spinner()
                                Text("Loading Workouts...")
                                    .font(.subheadline)
                            }
                        }
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
        .onDisappear {
            workoutsManager.updateWorkoutFilters()
        }
    }
    
    // Get number string for segmented picker
    func getNumberString(numberString: String) -> String {
        if numberString == "All" && workoutsManager.filteredWorkoutsCount != 0 {
            return "\(numberString) (\(workoutsManager.filteredWorkoutsCount))"
        } else {
            return numberString
        }
    }
}

