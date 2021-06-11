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
                
                AdvancedFilters()
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

