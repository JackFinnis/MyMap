//
//  MapSettings.swift
//  MyMap
//
//  Created by Finnis on 25/04/2021.
//

import SwiftUI
import MapKit

struct MapSettings: View {
    
    @Binding var mapType: MKMapType
    
    let mapTypeNames: [String] = ["Standard", "Satellite", "Hybrid"]
    let mapTypes: [MKMapType] = [.standard, .satellite, .hybrid]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Map Type")) {
                    Picker("Select a Map Type", selection: $mapType) {
                        ForEach(mapTypes, id: \.self) { type in
                            Text(mapTypeNames[mapTypes.firstIndex(of: type)!])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Map Settings")
        }
    }
}

