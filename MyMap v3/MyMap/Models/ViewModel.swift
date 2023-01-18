//
//  NewWorkoutManager.swift
//  MyMap
//
//  Created by Finnis on 13/02/2021.
//

import Foundation
import HealthKit
import MapKit
import SwiftUI

@MainActor
class ViewModel: NSObject, ObservableObject {
    // MARK: - Properties
    // Workout Tracking
    @Published var recording = false
    @Published var workoutType = WorkoutType.other
    @Published var startDate = Date()
    @Published var metres = 0.0
    @Published var coords = [CLLocationCoordinate2D]()
    var polyline: MKPolyline {
        MKPolyline(coordinates: coords, count: coords.count)
    }
    
    @Published var showPermissionsView = false
    @Published var healthUnavailable = !HKHelper.available
    @Published var healthStatus = HKAuthorizationStatus.notDetermined
    var healthAuth: Bool { healthStatus == .sharingAuthorized }
    
    let healthStore = HKHealthStore()
    var locationManager = CLLocationManager()
    var workoutBuilder: HKWorkoutBuilder?
    var routeBuilder: HKWorkoutRouteBuilder?
    
    // Map
    @Published var trackingMode = MKUserTrackingMode.none
    @Published var mapType = MKMapType.standard
    @Published var locationStatus = CLAuthorizationStatus.notDetermined
    var locationAuth: Bool { locationStatus == .authorizedAlways }
    var mapView: MKMapView?
    
    // Animations
    @Published var degrees = 0.0
    @Published var scale = 1.0
    
    // Workouts
    var workouts = [Workout]()
    @Published var selectedWorkout: Workout?
    @Published var loading = true
    
    // Filters
    @Published var showRuns = true
    @Published var showWalks = true
    @Published var showCycles = true
    @Published var showOthers = true
    @Published var workoutFilter: WorkoutFilter?
    
    // Errors
    @Published var showErrorAlert = false
    var error = MyMapError.noWorkouts
    func showError(_ error: MyMapError) {
        self.error = error
        showErrorAlert = true
    }
    
    // MARK: - Initialiser
    override init() {
        super.init()
        setupLocationManager()
        updateHealthStatus()
        showPermissionsView = !healthAuth
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationAuthorisation() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func updateHealthStatus() {
        healthStatus = HKHelper.status
    }
    
    func requestHealthAuthorisation() async {
        healthStatus = await HKHelper.requestAuth()
        if healthAuth {
            loadWorkouts()
        }
    }
    
    // MARK: - Workout Tracking
    func startWorkout(type: HKWorkoutActivityType) async {
        updateHealthStatus()
        guard healthAuth else { return }
        
        let config = HKWorkoutConfiguration()
        config.activityType = type
        config.locationType = .outdoor
        self.workoutType = WorkoutType(hkType: type)
        
        routeBuilder = HKWorkoutRouteBuilder(healthStore: healthStore, device: .local())
        workoutBuilder = HKWorkoutBuilder(healthStore: healthStore, configuration: config, device: .local())
        do {
            try await workoutBuilder?.beginCollection(at: .now)
        } catch {
            self.showError(.startingWorkout)
            return
        }
        
        locationManager.allowsBackgroundLocationUpdates = true
        updateTrackingMode(.followWithHeading)
        
        startDate = .now
        recording = true
    }
    
    func removePolyline() {
        mapView?.removeOverlays(mapView?.overlays(in: .aboveLabels) ?? [])
    }
    
    func endWorkout() async {
        locationManager.allowsBackgroundLocationUpdates = false
        
        let seconds = Date.now.timeIntervalSince(startDate)
        let workout = Workout(type: workoutType, polyline: polyline, date: startDate, seconds: seconds, meters: metres, calories: nil)
        workouts.append(workout)
        removePolyline()
        
        recording = false
        metres = 0
        coords = []
        
        do {
            try await workoutBuilder?.endCollection(at: .now)
            if let workout = try await workoutBuilder?.finishWorkout() {
                try await routeBuilder?.finishRoute(with: workout, metadata: nil)
            }
        } catch {
            self.showError(.endingWorkout)
        }
    }
    
    // MARK: - Workouts
    func loadWorkouts() {
        HKHelper.loadWorkouts { hkWorkouts in
            guard hkWorkouts.isNotEmpty else {
                self.showError(.noWorkouts)
                return
            }
            
            var tally = 0
            for hkWorkout in hkWorkouts {
                HKHelper.loadWorkoutRoute(hkWorkout: hkWorkout) { locations in
                    tally += 1
                    if locations.isNotEmpty {
                        let workout = Workout(hkWorkout: hkWorkout, locations: locations)
                        self.workouts.append(workout)
                    }
                    if tally == hkWorkouts.count {
                        self.filterWorkouts()
                    }
                }
            }
        }
    }
    
    func filterWorkouts() {
        mapView?.removeOverlays(mapView?.overlays(in: .aboveRoads) ?? [])
        let filteredWorkouts = workouts.filter { workout in
            (showRuns || workout.type != .run) &&
            (showWalks || workout.type != .walk) &&
            (showCycles || workout.type != .cycle) &&
            (showOthers || workout.type != .other) &&
            (workoutFilter == nil || Calendar.current.isDate(workout.date, equalTo: .now, toGranularity: workoutFilter!.granularity))
        }
        mapView?.addOverlays(filteredWorkouts, level: .aboveRoads)
    }
    
    // MARK: - Map
    func updateTrackingMode(_ newMode: MKUserTrackingMode) {
        mapView?.setUserTrackingMode(newMode, animated: true)
        if trackingMode == .followWithHeading || newMode == .followWithHeading {
            withAnimation(.easeInOut(duration: 0.25)) {
                scale = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.trackingMode = newMode
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.scale = 1
                }
            }
        } else {
            DispatchQueue.main.async {
                self.trackingMode = newMode
            }
        }
    }
    
    func updateMapType(_ newType: MKMapType) {
        mapView?.mapType = newType
        withAnimation(.easeInOut(duration: 0.25)) {
            degrees += 90
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.mapType = newType
            withAnimation(.easeInOut(duration: 0.3)) {
                self.degrees += 90
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard recording else { return }

        for location in locations {
            if let lastCoord = coords.last {
                metres += location.distance(from: lastCoord.location)
            }
            coords.append(location.coordinate)
        }
        
        removePolyline()
        mapView?.addOverlay(polyline, level: .aboveLabels)
        
        routeBuilder?.insertRouteData(locations) { success, error in
            guard success else {
                print("Error inserting locations")
                return
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationStatus = manager.authorizationStatus
        if locationAuth {
            manager.startUpdatingLocation()
            updateTrackingMode(.follow)
        } else {
            showPermissionsView = true
        }
    }
}

// MARK: - MKMapView Delegate
extension ViewModel: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let render = MKPolylineRenderer(polyline: polyline)
            render.lineWidth = 2
            render.strokeColor = .purple
            return render
        } else if let workout = overlay as? Workout {
            let render = MKPolylineRenderer(polyline: workout.polyline)
            render.lineWidth = 2
            render.strokeColor = UIColor(workout.type.colour)
            return render
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        if !animated {
            updateTrackingMode(.none)
        }
    }
}
