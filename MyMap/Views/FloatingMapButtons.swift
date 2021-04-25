//
//  FloatingMapButtons.swift
//  MyMap
//
//  Created by Finnis on 25/04/2021.
//

import SwiftUI
import MapKit

struct FloatingMapButtons: View {
    
    @Binding var mapType: MKMapType
    @Binding var userTrackingMode: MKUserTrackingMode
    
    @State var advancedSettingsShowing: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                VStack {
                    Button(action: {
                        advancedSettingsShowing = true
                    }, label: {
                        Image(systemName: "info.circle")
                    })
                    .padding(10)
                    .sheet(isPresented: $advancedSettingsShowing) {
                        MapSettings(mapType: $mapType)
                    }
                    
                    Button(action: {
                        updateUserTrackingMode()
                    }, label: {
                        switch userTrackingMode {
                        case .none:
                            Image(systemName: "location")
                        case .follow:
                            Image(systemName: "location.fill")
                        default:
                            Image(systemName: "location.north.line.fill")
                        }
                    })
                    .padding(10)
                }
                .background(Color(UIColor.white))
                .cornerRadius(11)
                .shadow(radius: 2)
                .padding(.horizontal, 10)
                .padding(.top, 50)
            }
            Spacer()
        }
    }
    
    func updateUserTrackingMode() {
        switch userTrackingMode {
        case .none:
            userTrackingMode = .follow
        case .follow:
            userTrackingMode = .followWithHeading
        default:
            userTrackingMode = .none
        }
    }
}
