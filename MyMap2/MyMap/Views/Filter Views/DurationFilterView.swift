//
//  DurationFilterView.swift
//  MyMap
//
//  Created by Finnis, Jack (PGW) on 11/06/2021.
//

import SwiftUI

struct DurationFilterView: View {
    @EnvironmentObject var workoutsManager: WorkoutsManager
    
    var body: some View {
        Form {
            Section {
                Toggle("Filter by Duration", isOn: $workoutsManager.durationFilter.filter.animation())
                if workoutsManager.durationFilter.filter {
                    HStack {
                        Text("Minimum Duration")
                        Spacer()
                        Text("\(workoutsManager.durationFilter.minimum, specifier: "%.0f") min")
                    }
                    Slider(value: $workoutsManager.durationFilter.minimum, in: 0...120, step: 5)
                    
                    HStack {
                        Text("Maximum Duration")
                        Spacer()
                        Text("\(workoutsManager.durationFilter.maximum, specifier: "%.0f") min")
                    }
                    Slider(value: $workoutsManager.durationFilter.maximum, in: 0...120, step: 5)
                }
            }
        }
    }
}
