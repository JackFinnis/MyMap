//
//  NewWorkoutInfoBar.swift
//  MyMap
//
//  Created by Finnis on 04/03/2021.
//

import SwiftUI

struct NewWorkoutInfoBar: View {
    @EnvironmentObject var newWorkoutManager: NewWorkoutManager
    @EnvironmentObject var workoutsManager: WorkoutsManager
    @EnvironmentObject var mapManager: MapManager
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                HStack {
                    Text(newWorkoutManager.elapsedSecondsString)
                        .font(.headline)
                        .padding(.leading, 50)
                    Spacer()
                    Text(newWorkoutManager.totalDistanceString)
                        .font(.headline)
                        .padding(.trailing, 50)
                }
                HStack {
                    HStack(spacing: 0) {
                        Button(action: {
                            newWorkoutManager.toggleWorkoutState()
                        }, label: {
                            Image(systemName: newWorkoutManager.toggleStateImageName)
                                .foregroundColor(.black)
                                .font(.title)
                        })
                        .frame(width: 44, height: 44)
                        .padding(3)
                        Divider()
                            .frame(height: 50)
                        EndButton()
                    }
                    .background(Color(UIColor.white))
                    .cornerRadius(12)
                }
            }
            .frame(height: 70)
            .background(Blur())
            .cornerRadius(12)
            .compositingGroup()
            .shadow(radius: 2, y: 2)
            .padding(10)
        }
    }
}
