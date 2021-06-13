//
//  WorkoutDetail.swift
//  MyMap
//
//  Created by Finnis on 25/04/2021.
//

import SwiftUI

struct WorkoutDetail: View {
    @EnvironmentObject var newWorkoutManager: NewWorkoutManager
    @EnvironmentObject var workoutsManager: WorkoutsManager
    
    var body: some View {
        Text("Workout Detail")
    }
}
