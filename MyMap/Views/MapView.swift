//
//  MapView.swift
//  MyMap
//
//  Created by Finnis on 14/02/2021.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    @EnvironmentObject var workoutDataStore: WorkoutDataStore
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var workoutsFilter: WorkoutsFilter
    
    @Binding var workoutState: WorkoutState
    
    @Binding var mapType: MKMapType
    @Binding var userTrackingMode: MKUserTrackingMode
    
    @Binding var findClosestRoute: Bool
    
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
        
        // Add overlays
        mapView.removeOverlays(mapView.overlays)
        // Add nearest workout
        if findClosestRoute {
            mapView.addOverlay(getClosestRoute(mapViewCenterCoordinate: mapView.centerCoordinate))
        }
        // Add previous workouts
        if workoutsFilter.isShowingWorkouts && workoutDataStore.finishedLoadingWorkoutRoutes {
            mapView.addOverlay(getFilteredWorkoutsMultiPolyline())
        }
        // Add current workout
        if workoutState != .notStarted {
            mapView.addOverlay(getCurrentWorkoutMultiPolyline())
        }
    }
    
    func getClosestRoute(mapViewCenterCoordinate: CLLocationCoordinate2D) -> MKMultiPolyline {
        let centerCoordinate = CLLocation(latitude: mapViewCenterCoordinate.latitude, longitude: mapViewCenterCoordinate.longitude)
        
        var minimumDistance: Double = .greatestFiniteMagnitude
        var closestPolyline = MKPolyline()
        
        for workout in workoutDataStore.workouts {
            for location in workout.routeLocations {
                let delta = location.distance(from: centerCoordinate)
                if delta < minimumDistance {
                    minimumDistance = delta
                    closestPolyline = workout.routePolyline
                }
            }
        }
        
        return MKMultiPolyline([closestPolyline])
    }
    
    func getFilteredWorkoutsMultiPolyline() -> MKMultiPolyline {
        return MKMultiPolyline(workoutDataStore.allWorkoutRoutePolylines)
    }
    
    func getCurrentWorkoutMultiPolyline() -> MKMultiPolyline {
        var polylines: [MKPolyline] = []
        
        for route in workoutManager.accumulatedLocations {
            var formattedLocations: [CLLocationCoordinate2D] = []
            for location in route {
                let newLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                formattedLocations.append(newLocation)
            }
            polylines.append(MKPolyline(coordinates: formattedLocations, count: formattedLocations.count))
        }
        
        var formattedLocations: [CLLocationCoordinate2D] = []
        
        for location in workoutManager.newLocations {
            let newLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            formattedLocations.append(newLocation)
        }
        polylines.append(MKPolyline(coordinates: formattedLocations, count: formattedLocations.count))
        
        return MKMultiPolyline(polylines)
    }
}
