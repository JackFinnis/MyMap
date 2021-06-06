//
//  MapView.swift
//  MyMap
//
//  Created by Finnis on 14/02/2021.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    // MARK: - Properties
    @EnvironmentObject var workoutDataStore: WorkoutDataStore
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var workoutsFilter: WorkoutsFilter
    
    @Binding var mapType: MKMapType
    @Binding var userTrackingMode: MKUserTrackingMode
    @Binding var searchState: WorkoutSearchState
    
    var mapView = MKMapView()
    
    // Filtered workouts
    var filteredWorkouts: [Workout] {
        workoutDataStore.workouts
    }
    
    // MARK: - Make Coordinator
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(self)
    }
    
    // MARK: - View State
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
        
        // Add overlays
        mapView.removeOverlays(mapView.overlays)
        // Add nearest workout
        if searchState == .found {
            mapView.addOverlay(getClosestRoute(center: mapView.centerCoordinate))
        }
        // Add current workout
        if workoutManager.workoutState != .notStarted {
            mapView.addOverlay(getCurrentWorkoutMultiPolyline())
        }
        // Add previous filtered workouts
        if workoutsFilter.showWorkouts && workoutDataStore.finishedLoading {
            mapView.addOverlay(getFilteredWorkoutsMultiPolyline())
        }
    }
    
    // MARK: - Helper Functions
    // Find the closest route to the center coordinate
    func getClosestRoute(center: CLLocationCoordinate2D) -> MKMultiPolyline {
        let centerCoordinate = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        var minimumDistance: Double = .greatestFiniteMagnitude
        var closestWorkout: Workout!
        
        for workout in filteredWorkouts {
            for location in workout.routeLocations {
                let delta = location.distance(from: centerCoordinate)
                if delta < minimumDistance {
                    minimumDistance = delta
                    closestWorkout = workout
                }
            }
        }
        
        return MKMultiPolyline(closestWorkout.routePolylines)
    }
    
    // Return the current workout polyline
    func getCurrentWorkoutMultiPolyline() -> MKMultiPolyline {
        var polylines: [MKPolyline] = []
        
        polylines.append(MKPolyline(coordinates: workoutManager.formattedNewLocations, count: workoutManager.formattedNewLocations.count))
        for segmentRouteLocations in workoutManager.formattedAccumulatedLocations {
            polylines.append(MKPolyline(coordinates: segmentRouteLocations, count: segmentRouteLocations.count))
        }
        
        return MKMultiPolyline(polylines)
    }
    
    // Return the filtered workouts multi polyline
    func getFilteredWorkoutsMultiPolyline() -> MKMultiPolyline {
        var polylines: [MKPolyline] = []
        
        for workout in filteredWorkouts {
            polylines.append(contentsOf: workout.routePolylines)
        }
        
        return MKMultiPolyline(polylines)
    }
}
