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
                            .frame(width: 48, height: 48)
                            .animation(.none, value: mapManager.mapTypeImageName)
                    })
                    
                    Divider()
                        .frame(width: 48)
                    
                    Button(action: {
                        mapManager.updateUserTrackingMode()
                    }, label: {
                        Image(systemName: mapManager.userTrackingModeImageName)
                            .frame(width: 48, height: 48)
                            .animation(.none, value: mapManager.userTrackingModeImageName)
                    })
                    
                    Divider()
                        .frame(width: 48)
                    
                    Button(action: {
                        showFilterWorkoutsSheet = true
                    }, label: {
                        Image(systemName: "figure.walk")
                            .frame(width: 48, height: 48)
                    })
                    
                    Divider()
                        .frame(width: 48)
                    
                    Button(action: {
                        updateSearchState()
                    }, label: {
                        Image(systemName: mapManager.searchStateImageName)
                            .frame(width: 48, height: 48)
                            .animation(.none, value: mapManager.searchStateImageName)
                    })
                }
                .font(.system(size: 24))
                .background(Blur())
                .cornerRadius(10)
                .compositingGroup()
                .shadow(color: Color(UIColor.systemFill), radius: 5)
                .padding(.trailing, 10)
                .padding(.top, 48)
            }
            Spacer()
        }
        .sheet(isPresented: $showFilterWorkoutsSheet) {
            FilterWorkouts(showFilterWorkoutsSheet: $showFilterWorkoutsSheet)
                .environmentObject(workoutsManager)
                .preferredColorScheme(mapManager.mapType == .standard ? .none : .dark)
        }
    }
    
    // Workout search button pressed
    func updateSearchState() {
        mapManager.userTrackingMode = .none
        switch mapManager.searchState {
        case .none:
            mapManager.searchState = .finding
        case .finding:
            mapManager.searchState = .found
            workoutsManager.setClosestRoute(center: centreCoordinate)
        case .found:
            mapManager.searchState = .none
            workoutsManager.selectedWorkout = nil
        }
    }
}
