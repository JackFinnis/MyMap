//
//  AdvancedFilters.swift
//  MyMap
//
//  Created by Finnis, Jack (PGW) on 11/06/2021.
//

import SwiftUI

struct AdvancedFilters: View {
    @EnvironmentObject var workoutsManager: WorkoutsManager
    @EnvironmentObject var mapManager: MapManager
    
    var body: some View {
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
            NavigationLink(destination: ElevationFilterView(), label: {
                HStack {
                    Text("Elevation")
                    Spacer()
                    Text(workoutsManager.elevationFilter.summary)
                        .foregroundColor(.secondary)
                }
            })
        }
    }
}
