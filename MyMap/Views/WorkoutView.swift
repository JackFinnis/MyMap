//
//  WorkoutView.swift
//  MyMap
//
//  Created by Finnis on 13/02/2021.
//

import SwiftUI
import MapKit

struct WorkoutView: View {
    
    // Access workout data store
    @EnvironmentObject var workoutDataStore: WorkoutDataStore
    
    @State var userTrackingMode: MKUserTrackingMode = .none
    @State var mapType: MKMapType = .standard
    
    // Setup HealthKit
    var healthKitSetupAssistant = HealthKitSetupAssistant()
    
    var body: some View {
        ZStack {
            MapView(mapType: $mapType, userTrackingMode: $userTrackingMode)
                .ignoresSafeArea()
            
            FloatingMapButtons(mapType: $mapType, userTrackingMode: $userTrackingMode)
            
            FloatingStateView(userTrackingMode: $userTrackingMode)
        }
        .onAppear {
            // Setup HealthKit
            healthKitSetupAssistant.requestAuthorisation()
            // Setup workout data store
            workoutDataStore.loadAllWorkoutRoutes()
        }
    }
}
