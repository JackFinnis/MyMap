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
    @EnvironmentObject var workoutsFilter: WorkoutsFilter
    
    @Binding var mapType: MKMapType
    @Binding var showSettingsSheet: Bool
    
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
                
                Section(header: Text("Display Workouts")) {
                    Picker("Number of Workouts Shown", selection: $workoutsFilter.numberShown.animation()) {
                        ForEach(WorkoutsShown.allCases, id: \.self) { number in
                            Text(number.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if workoutsFilter.showWorkouts {
                        if !workoutDataStore.finishedLoading {
                            HStack {
                                Spinner()
                                Text("Loading Workouts...")
                                    .font(.subheadline)
                            }
                        }
                        
                        if workoutsFilter.numberShown != .all {
                            Picker("Sort By", selection: $workoutsFilter.sortBy) {
                                ForEach(WorkoutsSortBy.allCases, id: \.self) { sortBy in
                                    Text(sortBy.rawValue)
                                }
                            }
                        }
                    }
                }
                
                Group {
                    Section(header: Text("Advanced Filters")) {
                        Toggle("Filter by Type", isOn: $workoutsFilter.filterByType.animation())
                        if workoutsFilter.filterByType {
                            Toggle("Display Walks", isOn: $workoutsFilter.displayWalks)
                            Toggle("Display Runs", isOn: $workoutsFilter.displayRuns)
                            Toggle("Display Cycles", isOn: $workoutsFilter.displayCycles)
                            Toggle("Display Other Workouts", isOn: $workoutsFilter.displayOther)
                        }
                    }
                    
                    Section {
                        Toggle("Filter by Date", isOn: $workoutsFilter.filterByDate.animation())
                        if workoutsFilter.filterByDate {
                            DatePicker("Start Date", selection: $workoutsFilter.startDate, displayedComponents: .date)
                            DatePicker("End Date", selection: $workoutsFilter.endDate, displayedComponents: .date)
                        }
                    }
                    
                    Section {
                        Toggle("Filter by Distance", isOn: $workoutsFilter.filterByDistance.animation())
                        if workoutsFilter.filterByDistance {
                            HStack {
                                Text("Minimum Distance")
                                Spacer()
                                Text("\(workoutsFilter.minimumDistance, specifier: "%.1f") km")
                            }
                            Slider(value: $workoutsFilter.minimumDistance, in: 0...10, step: 0.5)
                            
                            HStack {
                                Text("Maximum Distance")
                                Spacer()
                                Text("\(workoutsFilter.maximumDistance, specifier: "%.1f") km")
                            }
                            Slider(value: $workoutsFilter.maximumDistance, in: 0...10, step: 0.5)
                        }
                    }
                    
                    Section {
                        Toggle("Filter by Duration", isOn: $workoutsFilter.filterByDuration.animation())
                        if workoutsFilter.filterByDuration {
                            HStack {
                                Text("Minimum Duration")
                                Spacer()
                                Text("\(workoutsFilter.minimumDuration, specifier: "%.0f") min")
                            }
                            Slider(value: $workoutsFilter.minimumDuration, in: 0...120, step: 5)
                            
                            HStack {
                                Text("Maximum Duration")
                                Spacer()
                                Text("\(workoutsFilter.maximumDuration, specifier: "%.0f") min")
                            }
                            Slider(value: $workoutsFilter.maximumDuration, in: 0...120, step: 5)
                        }
                    }
                    
                    Section {
                        Toggle("Filter by Calories", isOn: $workoutsFilter.filterByCalories.animation())
                        if workoutsFilter.filterByCalories {
                            HStack {
                                Text("Minimum Calories")
                                Spacer()
                                Text("\(workoutsFilter.minimumCalories, specifier: "%.0f") cal")
                            }
                            Slider(value: $workoutsFilter.minimumCalories, in: 0...1000, step: 50)
                            
                            HStack {
                                Text("Maximum Calories")
                                Spacer()
                                Text("\(workoutsFilter.maximumCalories, specifier: "%.0f") cal")
                            }
                            Slider(value: $workoutsFilter.maximumCalories, in: 0...1000, step: 50)
                        }
                    }
                    
                    Section {
                        Toggle("Filter by Elevation", isOn: $workoutsFilter.filterByElevation.animation())
                        if workoutsFilter.filterByElevation {
                            HStack {
                                Text("Minimum Elevation")
                                Spacer()
                                Text("\(workoutsFilter.minimumElevation, specifier: "%.0f") m")
                            }
                            Slider(value: $workoutsFilter.minimumElevation, in: 0...500, step: 50)
                            
                            HStack {
                                Text("Maximum Elevation")
                                Spacer()
                                Text("\(workoutsFilter.maximumElevation, specifier: "%.0f") m")
                            }
                            Slider(value: $workoutsFilter.maximumElevation, in: 0...500, step: 50)
                        }
                    }
                }
            }
            .navigationTitle("Map Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        showSettingsSheet = false
                    }, label: {
                        Text("Done")
                    })
                }
            }
        }
    }
}

