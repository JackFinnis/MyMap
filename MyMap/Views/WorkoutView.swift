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
    
    @State var userTrackingMode: MKUserTrackingMode = .follow
    @State var mapType: MKMapType = .standard
    @State var showAllWorkouts: Bool = false
    
    // Setup HealthKit
    var healthKitSetupAssistant = HealthKitSetupAssistant()
    
    var body: some View {
        ZStack {
            MapView(mapType: $mapType, userTrackingMode: $userTrackingMode, showAllWorkouts: $showAllWorkouts)
                .ignoresSafeArea()
            
            FloatingMapButtons(mapType: $mapType, userTrackingMode: $userTrackingMode, showAllWorkouts: $showAllWorkouts)
            
            WorkoutStatusBar(userTrackingMode: $userTrackingMode)
        }
        .onAppear {
            // Setup HealthKit
            healthKitSetupAssistant.requestAuthorisation()
            // Setup workout data store
            workoutDataStore.loadAllWorkoutRoutes()
        }
    }
}
