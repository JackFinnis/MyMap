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
    @EnvironmentObject var workoutsSortBy: WorkoutsSortBy
    
    @Binding var workoutState: WorkoutState
    
    @Binding var mapType: MKMapType
    @Binding var userTrackingMode: MKUserTrackingMode
    
    @State var advancedSettingsShowing: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                VStack {
                    Button(action: {
                        advancedSettingsShowing = true
                    }, label: {
                        Image(systemName: "info.circle")
                            .padding(.top, 10)
                            .padding(.horizontal, 10)
                            .padding(.bottom, 5)
                    })
                    
                    Divider()
                        .frame(width: 25)
                    
                    Button(action: {
                        updateUserTrackingMode()
                    }, label: {
                        HStack {
                            switch userTrackingMode {
                            case .none:
                                Image(systemName: "location")
                            case .follow:
                                Image(systemName: "location.fill")
                            default:
                                Image(systemName: "location.north.line.fill")
                            }
                        }
                        .padding(.top, 5)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)
                    })
                }
                .background(Blur())
                .cornerRadius(11)
                .shadow(radius: 2)
                .padding(.horizontal, 10)
                .padding(.top, 50)
            }
            Spacer()
        }
        .sheet(isPresented: $advancedSettingsShowing) {
            MapSettings(mapType: $mapType)
                .environmentObject(workoutDataStore)
                .environmentObject(workoutsFilter)
                .environmentObject(workoutsSortBy)
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
}
