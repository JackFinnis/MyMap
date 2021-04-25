//
//  MapView.swift
//  MyMap
//
//  Created by Finnis on 14/02/2021.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    // Access environment object workout manager
    @EnvironmentObject var workoutManager: WorkoutManager
    
    // Access workout data store
    @EnvironmentObject var workoutDataStore: WorkoutDataStore
    
    @Binding var mapType: MKMapType
    @Binding var userTrackingMode: MKUserTrackingMode
    @Binding var showAllWorkouts: Bool
    
    var mapView = MKMapView()
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        // Set coordinator
        mapView.delegate = context.coordinator
        
        // Show user location, map scale and compass
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Set user tracking mode
        if mapView.userTrackingMode != userTrackingMode {
            mapView.setUserTrackingMode(userTrackingMode, animated: true)
        }
        
        // Set map type
        if mapView.mapType != mapType {
            mapView.mapType = mapType
        }
        
        mapView.removeOverlays(mapView.overlays)
        // Add all workout overlays
        if showAllWorkouts {
            mapView.addOverlay(multiPolyline())
        }
    }
    
    func multiPolyline() -> MKMultiPolyline {
        var polylines: [MKPolyline] = []
        
        // Provide polyline overlay for each of the workout routes
        for route in workoutDataStore.allWorkoutRoutes {
            var formattedLocations: [CLLocationCoordinate2D] = []
            for location in route {
                let newLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                formattedLocations.append(newLocation)
            }
            polylines.append(MKPolyline(coordinates: formattedLocations, count: route.count))
        }
        
        return MKMultiPolyline(polylines)
    }
}
