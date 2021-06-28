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
                                    .foregroundColor(.secondary)
                            }
                        }
                        Picker("Sort By", selection: $workoutsManager.sortBy) {
                            ForEach(WorkoutsSortBy.allCases, id: \.self) { sortBy in
                                Text(sortBy.rawValue)
                            }
                        }
                    }
                }
                // Advanced filters
                Section(header: Text("Advanced Filters")) {
                    NavigationLink(destination: TypeFilterView(), label: {
                        HStack {
                            Text("Type")
                            Spacer()
                            Text(workoutsManager.typeFilterSummary)
                                .foregroundColor(.secondary)
                        }
                    })
                    NavigationLink(destination: DateFilterView(), label: {
                        HStack {
                            Text("Date")
                            Spacer()
                            Text(workoutsManager.dateFilterSummary)
                                .foregroundColor(.secondary)
                        }
                    })
                    NavigationLink(destination: DistanceFilterView(), label: {
                        HStack {
                            Text("Distance")
                            Spacer()
                            Text(workoutsManager.distanceFilter.summary)
                                .foregroundColor(.secondary)
                        }
                    })
                    NavigationLink(destination: DurationFilterView(), label: {
                        HStack {
                            Text("Duration")
                            Spacer()
                            Text(workoutsManager.durationFilter.summary)
                                .foregroundColor(.secondary)
                        }
                    })
                    NavigationLink(destination: CaloriesFilterView(), label: {
                        HStack {
                            Text("Calories")
                            Spacer()
                            Text(workoutsManager.caloriesFilter.summary)
                                .foregroundColor(.secondary)
                        }
                    })
                }
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
    
    // Get number string for segmented picker
    func getNumberString(numberString: String) -> String {
        if numberString == "All" && workoutsManager.finishedLoading {
            return "\(numberString) (\(workoutsManager.filteredWorkoutsCount))"
        } else {
            return numberString
        }
    }
}

