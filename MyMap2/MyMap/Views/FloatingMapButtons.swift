//
//  FloatingMapButtons.swift
//  MyMap
//
//  Created by Finnis on 25/04/2021.
//

import SwiftUI

struct FloatingMapButtons: View {
    @EnvironmentObject var workoutsManager: WorkoutsManager
    @EnvironmentObject var mapManager: MapManager
    
    @State var showFilterWorkoutsSheet: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                VStack(spacing: 0) {
                    Button(action: {
                        mapManager.updateMapType()
                    }, label: {
                        Image(systemName: mapManager.mapTypeImageName)
                    })
                    Divider()
                        .frame(width: 40)
                    Button(action: {
                        mapManager.updateUserTrackingMode()
                    }, label: {
                        Image(systemName: mapManager.userTrackingModeImageName)
                    })
                    Divider()
                        .frame(width: 40)
                    Button(action: {
                        showFilterWorkoutsSheet = true
                    }, label: {
                        Image(systemName: "figure.walk")
                    })
                    Divider()
                        .frame(width: 40)
                    Button(action: {
                        mapManager.updateSearchState()
                    }, label: {
                        Image(systemName: mapManager.searchStateImageName)
                    })
                }
                .buttonStyle(FloatingButtonStyle())
                .background(Blur())
                .cornerRadius(10)
                .compositingGroup()
                .shadow(radius: 2, y: 2)
                .padding(.trailing)
                .padding(.top, 60)
            }
            Spacer()
        }
        .sheet(isPresented: $showFilterWorkoutsSheet) {
            FilterWorkouts(showFilterWorkoutsSheet: $showFilterWorkoutsSheet)
                .environmentObject(workoutsManager)
        }
    }
}
