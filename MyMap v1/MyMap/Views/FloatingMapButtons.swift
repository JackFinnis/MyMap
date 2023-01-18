//
//  FloatingMapButtons.swift
//  MyMap
//
//  Created by Finnis on 25/04/2021.
//

import SwiftUI

struct FloatingMapButtons: View {
    @EnvironmentObject var mapManager: MapManager
    
    @State var showMapSettingsSheet: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                VStack(spacing: 0) {
                    Button(action: {
                        showMapSettingsSheet = true
                    }, label: {
                        Image(systemName: "info.circle")
                    })
                    Divider()
                    Button(action: {
                        mapManager.updateUserTrackingMode()
                    }, label: {
                        Image(systemName: mapManager.userTrackingModeImageName)
                    })
                    Divider()
                    Button(action: {
                        mapManager.updateSearchState()
                    }, label: {
                        Image(systemName: mapManager.searchStateImageName)
                    })
                }
                .background(Blur())
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal, 10)
                .padding(.top, 50)
            }
            Spacer()
        }
        .sheet(isPresented: $showMapSettingsSheet) {
            MapSettings(showMapSettingsSheet: $showMapSettingsSheet)
                .environmentObject(mapManager)
        }
    }
}
