//
//  MapView.swift
//  MyMap
//
//  Created by Finnis on 14/02/2021.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var coordinate = CLLocationCoordinate2D(latitude: +51.18729392, longitude: -0.74440467)
    
    @State var region = MKCoordinateRegion()
    
    var body: some View {
        
        Map(coordinateRegion: $region)
            .onAppear {
                
                setRegion(coordinate)
            }
    }
    
    func setRegion(_ coordinate: CLLocationCoordinate2D) {
        
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
    }
}
