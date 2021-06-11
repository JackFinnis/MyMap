//
//  DateFilterView.swift
//  MyMap
//
//  Created by Finnis, Jack (PGW) on 11/06/2021.
//

import SwiftUI

struct DateFilterView: View {
    @EnvironmentObject var mapManager: MapManager
    
    var body: some View {
        Form {
            Section(header: Text("Workout Date")) {
                Toggle("Filter by Date", isOn: $mapManager.filterByDate.animation())
                if mapManager.filterByDate {
                    DatePicker("Start Date", selection: $mapManager.startDate, displayedComponents: .date)
                    DatePicker("End Date", selection: $mapManager.endDate, displayedComponents: .date)
                }
            }
        }
    }
}
