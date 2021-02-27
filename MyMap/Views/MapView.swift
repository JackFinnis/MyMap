//
//  MapView.swift
//  MyMap
//
//  Created by Finnis on 14/02/2021.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    // Access the workout data store
    let workoutDataStore = WorkoutDataStore()
    
    // Create map view
    var mapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        // Create map view
        mapView.delegate = context.coordinator
        
        // Show user location, map scale and compass
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        
        // This should only print once
        print("Make UIView")
        
        return mapView
    }
    
    func makeCoordinator() -> MapCoordinator {
        print("Make Coordinator")
        return MapCoordinator(self)
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // This function is called lots
        print("Update View")
        // Set map centre
        //mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
    func getUserRegion(mapView: MKMapView) -> MKCoordinateRegion {
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        return region
    }
}

// TODO:
// Pan to user at start
// Change to satellite image
// Pan to user having clicked button
// Point direction user is facing
// Add all workout routes

/* Old (Using SwiftUI):

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
