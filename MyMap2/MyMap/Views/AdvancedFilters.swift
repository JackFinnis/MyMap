//
//  AdvancedFilters.swift
//  MyMap
//
//  Created by Finnis, Jack (PGW) on 11/06/2021.
//

import SwiftUI

struct AdvancedFilters: View {
    @EnvironmentObject var mapManager: MapManager
    
    var body: some View {
        Section(header: Text("Advanced Workout Filters")) {
            NavigationLink(destination: TypeFilterView(), label: {
                HStack {
                    Text("Type")
                    Spacer()
                    Text(mapManager.typeFilterSummary)
                        .foregroundColor(.secondary)
                }
            })
            NavigationLink(destination: DateFilterView(), label: {
                HStack {
                    Text("Date")
                    Spacer()
                    Text(mapManager.dateFilterSummary)
                        .foregroundColor(.secondary)
                }
            })
            NavigationLink(destination: DistanceFilterView(), label: {
                HStack {
                    Text("Distance")
                    Spacer()
                    Text(mapManager.distanceFilter.summary)
                        .foregroundColor(.secondary)
                }
            })
            NavigationLink(destination: DurationFilterView(), label: {
                HStack {
                    Text("Duration")
                    Spacer()
                    Text(mapManager.durationFilter.summary)
                        .foregroundColor(.secondary)
                }
            })
            NavigationLink(destination: CaloriesFilterView(), label: {
                HStack {
                    Text("Calories")
                    Spacer()
                    Text(mapManager.caloriesFilter.summary)
                        .foregroundColor(.secondary)
                }
            })
            NavigationLink(destination: ElevationFilterView(), label: {
                HStack {
                    Text("Elevation")
                    Spacer()
                    Text(mapManager.elevationFilter.summary)
                        .foregroundColor(.secondary)
                }
            })
        }
    }
}
