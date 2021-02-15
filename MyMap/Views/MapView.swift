//
//  MapView.swift
//  MyMap
//
//  Created by Finnis on 14/02/2021.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        
        let map = MKMapView()
        map.delegate = context.coordinator
        
        // Show user location, map scale and compass
        map.showsUserLocation = true
        map.showsScale = true
        map.showsCompass = true
        
        return map
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
}

/* Old

// Access environment object workout manager
@EnvironmentObject var workoutManager: WorkoutManager

var mapManager = MapManager()

var userLocation = CLLocationCoordinate2D()

@State var region = MKCoordinateRegion()

var body: some View {
    
    Map(coordinateRegion: $region)
        .onAppear {
            // Centre on user
            setRegion(userLocation)
        }
        .ignoresSafeArea()
}

func setRegion(_ coordinate: CLLocationCoordinate2D) {
    
    region = MKCoordinateRegion(
        center: coordinate,
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )
}

 */
