//
//  WorkoutDetail.swift
//  MyMap
//
//  Created by Finnis on 25/04/2021.
//

import SwiftUI

struct WorkoutView: View {
    @Environment(\.dismiss) var dismiss
    
    let workout: Workout
    
    var body: some View {
        NavigationView {
            Form {
                Text("Type")
                    .badge(workout.type.rawValue)
                Text("Date")
                    .badge(workout.date.formatted())
                Text("Distance")
                    .badge(workout.metres?.formatted() ?? "")
                Text("Duration")
                    .badge(workout.seconds.formatted())
                Text("Calories")
                    .badge(workout.calories?.formatted() ?? "")
            }
            .navigationTitle("Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    DismissCross()
                }
                .buttonStyle(.plain)
            }
        }
        .if { view in
            if #available(iOS 16, *) {
                view.presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            } else {
                view
            }
        }
    }
}
