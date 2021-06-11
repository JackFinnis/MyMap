//
//  CaloriesFilterView.swift
//  MyMap
//
//  Created by Finnis, Jack (PGW) on 11/06/2021.
//

import SwiftUI

struct CaloriesFilterView: View {
    @EnvironmentObject var mapManager: MapManager
    
    var body: some View {
        Form {
            Section(header: Text("Workout Calories")) {
                Toggle("Filter by Calories", isOn: $mapManager.caloriesFilter.filter.animation())
                if mapManager.caloriesFilter.filter {
                    HStack {
                        Text("Minimum Calories")
                        Spacer()
                        Text("\(mapManager.caloriesFilter.minimum, specifier: "%.0f") cal")
                    }
                    Slider(value: $mapManager.caloriesFilter.minimum, in: 0...1000, step: 50)
                    
                    HStack {
                        Text("Maximum Calories")
                        Spacer()
                        Text("\(mapManager.caloriesFilter.maximum, specifier: "%.0f") cal")
                    }
                    Slider(value: $mapManager.caloriesFilter.maximum, in: 0...1000, step: 50)
                }
            }
        }
    }
}
