//
//  FloatingMapButtons.swift
//  MyMap
//
//  Created by Finnis on 25/04/2021.
//

import SwiftUI
import CoreLocation

struct FloatingMapButtons: View {
    @EnvironmentObject var workoutsManager: WorkoutsManager
    @EnvironmentObject var mapManager: MapManager
    
    @Binding var centreCoordinate: CLLocationCoordinate2D
    
    @State var showFilterWorkoutsSheet: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                VStack(spacing: 0) {
                    Button(action: {
                        mapManager.updateMapType()
                    }, label: {
                        Image(systemName: mapManager.mapTypeImageName)
                    })
                    .padding(3)
                    Divider()
                        .frame(width: 46)
                    Button(action: {
                        mapManager.updateUserTrackingMode()
                    }, label: {
                        Image(systemName: mapManager.userTrackingModeImageName)
                    })
                    .padding(3)
                    Divider()
                        .frame(width: 46)
                    Button(action: {
                        showFilterWorkoutsSheet = true
                    }, label: {
                        Image(systemName: "figure.walk")
                    })
                    .padding(3)
                    Divider()
                        .frame(width: 46)
                    Button(action: {
                        updateSearchState()
                    }, label: {
                        Image(systemName: mapManager.searchStateImageName)
                    })
                    .padding(3)
                }
                .buttonStyle(FloatingButtonStyle())
                .background(Blur())
                .cornerRadius(12)
                .compositingGroup()
                .shadow(radius: 2, y: 2)
                .padding(.trailing, 10)
                .padding(.top, 50)
            }
            Spacer()
        }
        .sheet(isPresented: $showFilterWorkoutsSheet) {
            FilterWorkouts(showFilterWorkoutsSheet: $showFilterWorkoutsSheet)
                .environmentObject(workoutsManager)
        }
    }
    
    // Workout search button pressed
    func updateSearchState() {
        mapManager.userTrackingMode = .none
        switch mapManager.searchState {
        case .none:
            mapManager.searchState = .finding
        case .finding:
            mapManager.searchState = .none
            workoutsManager.setClosestRoute(center: centreCoordinate)
        }
    }
}
