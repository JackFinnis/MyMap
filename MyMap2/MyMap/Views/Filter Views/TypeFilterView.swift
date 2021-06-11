//
//  TypeFilterView.swift
//  MyMap
//
//  Created by Finnis, Jack (PGW) on 11/06/2021.
//

import SwiftUI

struct TypeFilterView: View {
    @EnvironmentObject var mapManager: MapManager

    var body: some View {
        Form {
            Section(header: Text("Workout Type")) {
                Toggle("Filter by Type", isOn: $mapManager.filterByType.animation())
                if mapManager.filterByType {
                    Toggle("Display Walks", isOn: $mapManager.displayWalks)
                    Toggle("Display Runs", isOn: $mapManager.displayRuns)
                    Toggle("Display Cycles", isOn: $mapManager.displayCycles)
                    Toggle("Display Other Workouts", isOn: $mapManager.displayOther)
                }
            }
        }
    }
}
