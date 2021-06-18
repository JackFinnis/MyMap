//
//  MapView.swift
//  MyMap
//
//  Created by Finnis on 14/02/2021.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @EnvironmentObject var newWorkoutManager: NewWorkoutManager
    @EnvironmentObject var workoutsManager: WorkoutsManager
    @EnvironmentObject var mapManager: MapManager
    
    @Binding var centreCoordinate: CLLocationCoordinate2D
    
    var mapView = MKMapView()

    func makeCoordinator() -> MapManager {
        mapManager.parent = self
        return mapManager
    }

    func makeUIView(context: Context) -> MKMapView {
        // Set delegate
        mapView.delegate = context.coordinator
        
        // Show user location, map scale and compass
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        print("update")
        // Set user tracking mode
        if mapView.userTrackingMode != mapManager.userTrackingMode {
            mapView.setUserTrackingMode(mapManager.userTrackingMode, animated: true)
        }
        // Set map type
        if mapView.mapType != mapManager.mapType {
            mapView.mapType = mapManager.mapType
        }
        
        // Updated polyline overlays
        mapView.removeOverlays(mapView.overlays)
        // Add new workout polyline
        mapView.addOverlays(newWorkoutManager.getCurrentWorkoutMultiPolyline())
        // Add filtered workouts polylines
        if workoutsManager.showWorkouts && workoutsManager.finishedLoading {
            mapView.addOverlays(workoutsManager.getFilteredWorkoutsMultiPolyline())
        }
    }
}
