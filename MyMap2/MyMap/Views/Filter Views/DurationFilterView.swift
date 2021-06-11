//
//  DurationFilterView.swift
//  MyMap
//
//  Created by Finnis, Jack (PGW) on 11/06/2021.
//

import SwiftUI

struct DurationFilterView: View {
    @EnvironmentObject var mapManager: MapManager
    
    var body: some View {
        Form {
            Section(header: Text("Workout Duration")) {
                Toggle("Filter by Duration", isOn: $mapManager.durationFilter.filter.animation())
                if mapManager.durationFilter.filter {
                    HStack {
                        Text("Minimum Duration")
                        Spacer()
                        Text("\(mapManager.durationFilter.minimum, specifier: "%.0f") min")
                    }
                    Slider(value: $mapManager.durationFilter.minimum, in: 0...120, step: 5)
                    
                    HStack {
                        Text("Maximum Duration")
                        Spacer()
                        Text("\(mapManager.durationFilter.maximum, specifier: "%.0f") min")
                    }
                    Slider(value: $mapManager.durationFilter.maximum, in: 0...120, step: 5)
                }
            }
        }
    }
}
