//
//  DistanceFilter.swift
//  MyMap
//
//  Created by Finnis, Jack (PGW) on 11/06/2021.
//

import SwiftUI

struct DistanceFilterView: View {
    @EnvironmentObject var workoutsManager: WorkoutsManager
    
    var body: some View {
        Form {
            Section {
                Toggle("Filter by Distance", isOn: $workoutsManager.distanceFilter.filter.animation())
                if workoutsManager.distanceFilter.filter {
                    HStack {
                        Text("Minimum Distance")
                        Spacer()
                        Text("\(workoutsManager.distanceFilter.minimum, specifier: "%.1f") km")
                    }
                    Slider(value: $workoutsManager.distanceFilter.minimum, in: 0...10, step: 0.5)
                    
                    HStack {
                        Text("Maximum Distance")
                        Spacer()
                        Text("\(workoutsManager.distanceFilter.maximum, specifier: "%.1f") km")
                    }
                    Slider(value: $workoutsManager.distanceFilter.maximum, in: 0...10, step: 0.5)
                }
            }
        }
    }
}
