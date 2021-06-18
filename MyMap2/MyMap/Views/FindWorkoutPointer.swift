//
//  FindWorkoutPointer.swift
//  MyMap
//
//  Created by Finnis on 13/06/2021.
//

import SwiftUI
import CoreLocation

struct FindWorkoutPointer: View {
    @EnvironmentObject var workoutsManager: WorkoutsManager
    @EnvironmentObject var mapManager: MapManager
    
    @Binding var centreCoordinate: CLLocationCoordinate2D
    
    var body: some View {
        if mapManager.searchState == .finding {
            Button(action: {
                mapManager.userTrackingMode = .none
                mapManager.searchState = .none
                workoutsManager.setClosestRoute(center: centreCoordinate)
            }, label: {
                Image(systemName: "circle")
            })
            .buttonStyle(FloatingButtonStyle())
        }
    }
}
