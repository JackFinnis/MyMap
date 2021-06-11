//
//  ElevationFilterView.swift
//  MyMap
//
//  Created by Finnis, Jack (PGW) on 11/06/2021.
//

import SwiftUI

struct ElevationFilterView: View {
    @EnvironmentObject var mapManager: MapManager
    
    var body: some View {
        Form {
            Section(header: Text("Workout Elevation")) {
                Toggle("Filter by Elevation", isOn: $mapManager.elevationFilter.filter.animation())
                if mapManager.elevationFilter.filter {
                    HStack {
                        Text("Minimum Elevation")
                        Spacer()
                        Text("\(mapManager.elevationFilter.minimum, specifier: "%.0f") m")
                    }
                    Slider(value: $mapManager.elevationFilter.minimum, in: 0...500, step: 50)
                    
                    HStack {
                        Text("Maximum Elevation")
                        Spacer()
                        Text("\(mapManager.elevationFilter.maximum, specifier: "%.0f") m")
                    }
                    Slider(value: $mapManager.elevationFilter.maximum, in: 0...500, step: 50)
                }
            }
        }
    }
}
