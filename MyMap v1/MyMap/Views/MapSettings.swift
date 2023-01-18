//
//  MapSettings.swift
//  MyMap
//
//  Created by Finnis on 25/04/2021.
//

import SwiftUI

struct MapSettings: View {
    @EnvironmentObject var mapManager: MapManager
    
    @Binding var showMapSettingsSheet: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Map Type")) {
                    Picker("Select a Map Type", selection: $mapManager.mapType) {
                        ForEach(mapManager.mapTypes, id: \.self) { type in
                            Text(mapManager.mapTypeNames[mapManager.mapTypes.firstIndex(of: type)!])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Display Workouts")) {
                    Picker("Number of Workouts Shown", selection: $mapManager.numberShown.animation()) {
                        ForEach(WorkoutsShown.allCases, id: \.self) { number in
                            Text(number.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if mapManager.showWorkouts {
                        if !mapManager.finishedLoading {
                            HStack {
                                Spinner()
                                Text("Loading Workouts...")
                                    .font(.subheadline)
                            }
                        }
                        if mapManager.numberShown != .all {
                            Picker("Sort By", selection: $mapManager.sortBy) {
                                ForEach(WorkoutsSortBy.allCases, id: \.self) { sortBy in
                                    Text(sortBy.rawValue)
                                }
                            }
                        }
                    }
                }
                
                Group {
                    Section(header: Text("Advanced Filters")) {
                        Toggle("Filter by Type", isOn: $mapManager.filterByType.animation())
                        if mapManager.filterByType {
                            Toggle("Display Walks", isOn: $mapManager.displayWalks)
                            Toggle("Display Runs", isOn: $mapManager.displayRuns)
                            Toggle("Display Cycles", isOn: $mapManager.displayCycles)
                            Toggle("Display Other Workouts", isOn: $mapManager.displayOther)
                        }
                    }
                    
                    Section {
                        Toggle("Filter by Date", isOn: $mapManager.filterByDate.animation())
                        if mapManager.filterByDate {
                            DatePicker("Start Date", selection: $mapManager.startDate, displayedComponents: .date)
                            DatePicker("End Date", selection: $mapManager.endDate, displayedComponents: .date)
                        }
                    }
                    
                    Section {
                        Toggle("Filter by Distance", isOn: $mapManager.filterByDistance.animation())
                        if mapManager.filterByDistance {
                            HStack {
                                Text("Minimum Distance")
                                Spacer()
                                Text("\(mapManager.minimumDistance, specifier: "%.1f") km")
                            }
                            Slider(value: $mapManager.minimumDistance, in: 0...10, step: 0.5)
                            
                            HStack {
                                Text("Maximum Distance")
                                Spacer()
                                Text("\(mapManager.maximumDistance, specifier: "%.1f") km")
                            }
                            Slider(value: $mapManager.maximumDistance, in: 0...10, step: 0.5)
                        }
                    }
                    
                    Section {
                        Toggle("Filter by Duration", isOn: $mapManager.filterByDuration.animation())
                        if mapManager.filterByDuration {
                            HStack {
                                Text("Minimum Duration")
                                Spacer()
                                Text("\(mapManager.minimumDuration, specifier: "%.0f") min")
                            }
                            Slider(value: $mapManager.minimumDuration, in: 0...120, step: 5)
                            
                            HStack {
                                Text("Maximum Duration")
                                Spacer()
                                Text("\(mapManager.maximumDuration, specifier: "%.0f") min")
                            }
                            Slider(value: $mapManager.maximumDuration, in: 0...120, step: 5)
                        }
                    }
                    
                    Section {
                        Toggle("Filter by Calories", isOn: $mapManager.filterByCalories.animation())
                        if mapManager.filterByCalories {
                            HStack {
                                Text("Minimum Calories")
                                Spacer()
                                Text("\(mapManager.minimumCalories, specifier: "%.0f") cal")
                            }
                            Slider(value: $mapManager.minimumCalories, in: 0...1000, step: 50)
                            
                            HStack {
                                Text("Maximum Calories")
                                Spacer()
                                Text("\(mapManager.maximumCalories, specifier: "%.0f") cal")
                            }
                            Slider(value: $mapManager.maximumCalories, in: 0...1000, step: 50)
                        }
                    }
                    
                    Section {
                        Toggle("Filter by Elevation", isOn: $mapManager.filterByElevation.animation())
                        if mapManager.filterByElevation {
                            HStack {
                                Text("Minimum Elevation")
                                Spacer()
                                Text("\(mapManager.minimumElevation, specifier: "%.0f") m")
                            }
                            Slider(value: $mapManager.minimumElevation, in: 0...500, step: 50)
                            
                            HStack {
                                Text("Maximum Elevation")
                                Spacer()
                                Text("\(mapManager.maximumElevation, specifier: "%.0f") m")
                            }
                            Slider(value: $mapManager.maximumElevation, in: 0...500, step: 50)
                        }
                    }
                }
            }
            .navigationTitle("Map Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        showMapSettingsSheet = false
                    }, label: {
                        Text("Done")
                    })
                }
            }
        }
    }
}

