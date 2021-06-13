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
    
    var mapView = MKMapView()

    func makeCoordinator() -> MapManager {
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
        // Set user tracking mode
        if mapView.userTrackingMode != mapManager.userTrackingMode {
            mapView.setUserTrackingMode(mapManager.userTrackingMode, animated: true)
        }
        // Set map type
        if mapView.mapType != mapManager.mapType {
            mapView.mapType = mapManager.mapType
        }
        
        // Add updated overlays
        mapView.removeOverlays(mapView.overlays)
        // Add nearest workout
        if mapManager.searchState == .found {
            mapView.addOverlay(workoutsManager.getClosestRoute(center: mapView.centerCoordinate))
        }
        // Add current workout
        if newWorkoutManager.workoutState != .notStarted {
            mapView.addOverlay(newWorkoutManager.getCurrentWorkoutMultiPolyline())
        }
        // Add previous filtered workouts
        if workoutsManager.showWorkouts && workoutsManager.finishedLoading {
            mapView.addOverlay(workoutsManager.getFilteredWorkoutsMultiPolyline())
        }
    }
}
