//
//  WorkoutDetail.swift
//  MyMap
//
//  Created by Finnis on 25/04/2021.
//

import SwiftUI

struct WorkoutDetail: View {
    
    @EnvironmentObject var workoutDataStore: WorkoutDataStore
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var workoutsFilter: WorkoutsFilter
    @EnvironmentObject var workoutsSortBy: WorkoutsSortBy
    
    var body: some View {
        Text("Workout Detail")
    }
}
