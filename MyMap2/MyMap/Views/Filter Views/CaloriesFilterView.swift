//
//  CaloriesFilterView.swift
//  MyMap
//
//  Created by Finnis, Jack (PGW) on 11/06/2021.
//

import SwiftUI

struct CaloriesFilterView: View {
    @EnvironmentObject var workoutsManager: WorkoutsManager
    
    var body: some View {
        Form {
            Section {
                Toggle("Filter by Calories", isOn: $workoutsManager.caloriesFilter.filter.animation())
                if workoutsManager.caloriesFilter.filter {
                    HStack {
                        Text("Minimum Calories")
                        Spacer()
                        Text("\(workoutsManager.caloriesFilter.minimum, specifier: "%.0f") cal")
                    }
                    Slider(value: $workoutsManager.caloriesFilter.minimum, in: 0...1000, step: 50)
                    
                    HStack {
                        Text("Maximum Calories")
                        Spacer()
                        Text("\(workoutsManager.caloriesFilter.maximum, specifier: "%.0f") cal")
                    }
                    Slider(value: $workoutsManager.caloriesFilter.maximum, in: 0...1000, step: 50)
                }
            }
        }
    }
}
