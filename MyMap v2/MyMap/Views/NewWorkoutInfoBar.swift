//
//  NewWorkoutInfoBar.swift
//  MyMap
//
//  Created by Finnis on 04/03/2021.
//

import SwiftUI

struct NewWorkoutInfoBar: View {
    @Environment(\.colorScheme) var colourScheme
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
                        .padding(.leading)
                        .animation(.none, value: newWorkoutManager.elapsedSecondsString)
                    Spacer()
                    Text(newWorkoutManager.totalDistanceString)
                        .font(.headline)
                        .padding(.trailing)
                        .animation(.none, value: newWorkoutManager.totalDistanceString)
                }
                
                HStack(spacing: 0) {
                    Button(action: {
                        newWorkoutManager.toggleWorkoutState()
                    }, label: {
                        Image(systemName: newWorkoutManager.toggleStateImageName)
                            .font(.title)
                            .frame(width: 48, height: 48)
                            .foregroundColor(colourScheme == .light ? .black : .white)
                            .animation(.none, value: newWorkoutManager.toggleStateImageName)
                    })
                    
                    Divider()
                        .frame(height: 48)
                    
                    EndButton()
                }
                .background(colourScheme == .light ? Color.white : Color.black)
                .cornerRadius(10)
            }
            .frame(height: 70)
            .background(Blur())
            .cornerRadius(10)
            .compositingGroup()
            .shadow(color: Color(UIColor.systemFill), radius: 5)
            .padding(10)
        }
    }
}
