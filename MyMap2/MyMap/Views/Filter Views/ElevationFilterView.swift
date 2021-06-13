//
//  ElevationFilterView.swift
//  MyMap
//
//  Created by Finnis, Jack (PGW) on 11/06/2021.
//

import SwiftUI

struct ElevationFilterView: View {
    @EnvironmentObject var workoutsManager: WorkoutsManager
    
    var body: some View {
        Form {
            Section {
                Toggle("Filter by Elevation", isOn: $workoutsManager.elevationFilter.filter.animation())
                if workoutsManager.elevationFilter.filter {
                    HStack {
                        Text("Minimum Elevation")
                        Spacer()
                        Text("\(workoutsManager.elevationFilter.minimum, specifier: "%.0f") m")
                    }
                    Slider(value: $workoutsManager.elevationFilter.minimum, in: 0...500, step: 50)
                    
                    HStack {
                        Text("Maximum Elevation")
                        Spacer()
                        Text("\(workoutsManager.elevationFilter.maximum, specifier: "%.0f") m")
                    }
                    Slider(value: $workoutsManager.elevationFilter.maximum, in: 0...500, step: 50)
                }
            }
        }
    }
}
