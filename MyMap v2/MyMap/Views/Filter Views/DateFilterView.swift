//
//  DateFilterView.swift
//  MyMap
//
//  Created by Finnis, Jack (PGW) on 11/06/2021.
//

import SwiftUI

struct DateFilterView: View {
    @EnvironmentObject var workoutsManager: WorkoutsManager
    
    var body: some View {
        Form {
            Section {
                Toggle("Filter by Date", isOn: $workoutsManager.filterByDate.animation())
                if workoutsManager.filterByDate {
                    DatePicker("Start Date", selection: $workoutsManager.startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $workoutsManager.endDate, displayedComponents: .date)
                }
            }
        }
    }
}
