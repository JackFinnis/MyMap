//
//  DistanceFilter.swift
//  MyMap
//
//  Created by Finnis, Jack (PGW) on 11/06/2021.
//

import SwiftUI

struct DistanceFilterView: View {
    @EnvironmentObject var mapManager: MapManager
    
    var body: some View {
        Form {
            Section(header: Text("Workout Distance")) {
                Toggle("Filter by Distance", isOn: $mapManager.distanceFilter.filter.animation())
                if mapManager.distanceFilter.filter {
                    HStack {
                        Text("Minimum Distance")
                        Spacer()
                        Text("\(mapManager.distanceFilter.minimum, specifier: "%.1f") km")
                    }
                    Slider(value: $mapManager.distanceFilter.minimum, in: 0...10, step: 0.5)
                    
                    HStack {
                        Text("Maximum Distance")
                        Spacer()
                        Text("\(mapManager.distanceFilter.maximum, specifier: "%.1f") km")
                    }
                    Slider(value: $mapManager.distanceFilter.maximum, in: 0...10, step: 0.5)
                }
            }
        }
    }
}
