//
//  FloatingMapButtons.swift
//  MyMap
//
//  Created by Finnis on 25/04/2021.
//

import SwiftUI
import MapKit

struct FloatingMapButtons: View {
    @EnvironmentObject var workoutDataStore: WorkoutDataStore
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var workoutsFilter: WorkoutsFilter
    @EnvironmentObject var mapManager: MapManager
    
    @State var showMapSettingsSheet: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Button(action: {
                        showMapSettingsSheet = true
                    }, label: {
                        Image(systemName: "info.circle")
                    })
                    Divider()
                    Button(action: {
                        mapManager.updateUserTrackingMode()
                    }, label: {
                        Image(systemName: mapManager.userTrackingModeImageName)
                    })
                    Divider()
                    Button(action: {
                        mapManager.updateSearchState()
                    }, label: {
                        Image(systemName: mapManager.searchStateImageName)
                    })
                }
                .buttonStyle(FloatingButtonStyle())
                .background(Blur())
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal, 10)
                .padding(.top, 50)
            }
            Spacer()
        }
        .sheet(isPresented: $showMapSettingsSheet) {
            MapSettings(showMapSettingsSheet: $showMapSettingsSheet)
                .environmentObject(workoutDataStore)
                .environmentObject(workoutsFilter)
                .environmentObject(mapManager)
        }
    }
}
