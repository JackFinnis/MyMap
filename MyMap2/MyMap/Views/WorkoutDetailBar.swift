//
//  WorkoutDetailBar.swift
//  MyMap
//
//  Created by Finnis on 13/06/2021.
//

import SwiftUI

struct WorkoutDetailBar: View {
    @EnvironmentObject var newWorkoutManager: NewWorkoutManager
    @EnvironmentObject var workoutsManager: WorkoutsManager
    @EnvironmentObject var mapManager: MapManager
    
    var body: some View {
        if newWorkoutManager.workoutState != .notStarted {
            NewWorkoutInfoBar()
        } else {
            WorkoutInfoBar()
        }
    }
}
