//
//  MyMapApp.swift
//  MyMap
//
//  Created by Finnis on 27/01/2021.
//

import SwiftUI

@main
struct MyMapApp: App {
    
//    // Access workout manager business logic:
//    @ObservedObject var workoutManager = WorkoutManager()
    
    var body: some Scene {
        WindowGroup {
            WorkoutView()
//                .environmentObject(workoutManager)
        }
    }
}
