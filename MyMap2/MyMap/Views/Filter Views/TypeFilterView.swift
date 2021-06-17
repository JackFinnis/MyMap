//
//  TypeFilterView.swift
//  MyMap
//
//  Created by Finnis, Jack (PGW) on 11/06/2021.
//

import SwiftUI

struct TypeFilterView: View {
    @EnvironmentObject var workoutsManager: WorkoutsManager

    var body: some View {
        Form {
            Section {
                Toggle("Filter by Type", isOn: $workoutsManager.filterByType.animation())
                if workoutsManager.filterByType {
                    Toggle("Display Walks", isOn: $workoutsManager.displayWalks)
                        .accentColor(Color(UIColor.systemRed))
                    Toggle("Display Runs", isOn: $workoutsManager.displayRuns)
                        .accentColor(Color(UIColor.systemGreen))
                    Toggle("Display Cycles", isOn: $workoutsManager.displayCycles)
                        .accentColor(Color(UIColor.systemBlue))
                    Toggle("Display Other Workouts", isOn: $workoutsManager.displayOther)
                        .accentColor(Color(UIColor.systemOrange))
                }
            }
        }
    }
}
