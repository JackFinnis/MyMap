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
    
    @Binding var mapType: MKMapType
    @Binding var userTrackingMode: MKUserTrackingMode
    @Binding var searchState: WorkoutSearchState
    
    @State var showSettingsSheet: Bool = false
    
    var userTrackingModeImageName: String {
        switch userTrackingMode {
        case .none:
            return "location"
        case .follow:
            return "location.fill"
        default:
            return "location.north.line.fill"
        }
    }
    var searchStateImageName: String {
        switch searchState {
        case .none:
            return "magnifyingglass"
        case .finding:
            return "magnifyingglass"
        default:
            return "magnifyingglass"
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Button(action: {
                        showSettingsSheet = true
                    }, label: {
                        Image(systemName: "info.circle")
                    })
                    Divider()
                    Button(action: {
                        updateUserTrackingMode()
                    }, label: {
                        Image(systemName: userTrackingModeImageName)
                    })
                    Divider()
                    Button(action: {
                        updateSearchState()
                    }, label: {
                        Image(systemName: searchStateImageName)
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
        .sheet(isPresented: $showSettingsSheet) {
            MapSettings(mapType: $mapType, showSettingsSheet: $showSettingsSheet)
                .environmentObject(workoutDataStore)
                .environmentObject(workoutsFilter)
        }
    }
    
    func updateUserTrackingMode() {
        switch userTrackingMode {
        case .none:
            userTrackingMode = .follow
        case .follow:
            userTrackingMode = .followWithHeading
        default:
            userTrackingMode = .none
        }
    }
    
    func updateSearchState() {
        switch searchState {
        case .none:
            searchState = .finding
        case .finding:
            searchState = .found
        default:
            searchState = .none
        }
    }
}
