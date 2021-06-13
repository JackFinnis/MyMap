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
                        Image(systemName: "line.horizontal.3.decrease.circle")
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
                .compositingGroup()
                .shadow(radius: 1)
                .cornerRadius(10)
                .padding(.trailing, 10)
                .padding(.top, 50)
            }
            Spacer()
        }
        .sheet(isPresented: $showFilterWorkoutsSheet) {
            FilterWorkouts(showFilterWorkoutsSheet: $showFilterWorkoutsSheet)
                .environmentObject(workoutsManager)
        }
    }
}
