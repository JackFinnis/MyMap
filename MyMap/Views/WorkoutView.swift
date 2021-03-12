//
//  WorkoutView.swift
//  MyMap
//
//  Created by Finnis on 13/02/2021.
//

import SwiftUI

struct WorkoutView: View {
    
    // Setup HealthKit
    var healthKitSetupAssistant = HealthKitSetupAssistant()
    
    var body: some View {
        ZStack {
            MapView()
                .ignoresSafeArea()
            
            FloatingStateView()
        }
        .onAppear {
            // Setup HealthKit
            healthKitSetupAssistant.requestAuthorisation()
        }
    }
}

/* Old (Get status bar frame):

.frame(width: UIScreen.main.bounds.width, height:  UIApplication.shared.statusBarFrame.height)
 
*/
