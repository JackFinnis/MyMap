//
//  MyMapApp.swift
//  MyMap
//
//  Created by Finnis on 27/01/2021.
//

import SwiftUI

@main
struct MyMapApp: App {
    // Access the business logic:
    var workoutManager = WorkoutManager()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                WorkoutView()
                    .environmentObject(workoutManager)
            }
        }
    }
}
