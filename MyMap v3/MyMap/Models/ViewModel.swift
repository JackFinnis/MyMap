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
import Combine

@MainActor
class ViewModel: NSObject, ObservableObject {
    // MARK: - Properties
    // Workout Tracking
    @Published var recording = false
    @Published var type = WorkoutType.other
    @Published var startDate = Date()
    @Published var metres = 0.0
    @Published var locations = [CLLocation]()
    var polyline: MKPolyline {
        let coords = locations.map(\.coordinate)
        return MKPolyline(coordinates: coords, count: coords.count)
    }
    var newWorkout: Workout {
        let duration = Date.now.timeIntervalSince(startDate)
        return Workout(type: type, polyline: polyline, locations: locations, date: startDate, duration: duration)
    }
    
    @Published var showPermissionsView = false
    @Published var healthUnavailable = !HKHelper.available
    @Published var healthStatus = HKAuthorizationStatus.notDetermined
    @Published var healthLoading = false
    var healthAuth: Bool { healthStatus == .sharingAuthorized }
    
    let healthStore = HKHealthStore()
    var locationManager = CLLocationManager()
    var workoutBuilder: HKWorkoutBuilder?
    var routeBuilder: HKWorkoutRouteBuilder?
    var timer: Cancellable?
    
    // Map
    @Published var trackingMode = MKUserTrackingMode.none
    @Published var mapType = MKMapType.standard
    @Published var accuracyAuth = false
    @Published var locationStatus = CLAuthorizationStatus.notDetermined
    var locationAuth: Bool { locationStatus == .authorizedAlways }
    var mapView: MKMapView?
    
    // Workouts
    @Published var workouts = [Workout]()
    @Published var filteredWorkouts = [Workout]()
    @Published var loadingWorkouts = true
    @Published var selectedWorkout: Workout? { didSet {
        updatePolylines()
        filterWorkouts()
    }}
    
    // Filters
    @Published var workoutType: WorkoutType? { didSet {
        filterWorkouts()
    }}
    @Published var workoutDate: WorkoutDate? { didSet {
        filterWorkouts()
    }}
    
    // View
    @Published var degrees = 0.0
    @Published var scale = 1.0
    @Published var pulse = false
    @Published var showInfoView = false
    @Defaults(key: "shownNoWorkoutsError", defaultValue: false) var shownNoWorkoutsError
    
    // Errors
    @Published var showErrorAlert = false
    @Published var error = MyMapError.noWorkouts
    func showError(_ error: MyMapError) {
        self.error = error
        self.showErrorAlert = true
        Haptics.error()
    }
    
    // MARK: - Initialiser
    override init() {
        super.init()
        setupLocationManager()
        updateHealthStatus()
        if healthAuth {
            loadWorkouts()
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
    }
    
    func requestLocationAuthorisation() {
        if locationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func updateHealthStatus() {
        healthStatus = HKHelper.status
        if !healthAuth {
            showPermissionsView = true
        }
    }
    
    func requestHealthAuthorisation() async {
        healthLoading = true
        healthStatus = await HKHelper.requestAuth()
        if healthAuth {
            loadWorkouts()
        }
        healthLoading = false
    }
    
    // MARK: - Workouts
    func loadWorkouts() {
        loadingWorkouts = true
        HKHelper.loadWorkouts { hkWorkouts in
            guard hkWorkouts.isNotEmpty else {
                DispatchQueue.main.async {
                    self.loadingWorkouts = false
                    if !self.shownNoWorkoutsError {
                        self.shownNoWorkoutsError = true
                        self.showError(.noWorkouts)
                    }
                }
                return
            }
            
            var tally = 0
            for hkWorkout in hkWorkouts {
                HKHelper.loadWorkoutRoute(hkWorkout: hkWorkout) { locations in
                    tally += 1
                    if locations.isNotEmpty {
                        let workout = Workout(hkWorkout: hkWorkout, locations: locations)
                        DispatchQueue.main.async {
                            self.workouts.append(workout)
                            if self.showWorkout(workout) {
                                self.filteredWorkouts.append(workout)
                                self.mapView?.addOverlay(workout, level: .aboveRoads)
                            }
                        }
                    }
                    if tally == hkWorkouts.count {
                        DispatchQueue.main.async {
                            Haptics.success()
                            self.loadingWorkouts = false
                        }
                    }
                }
            }
        }
    }
    
    func filterWorkouts() {
        mapView?.removeOverlays(mapView?.overlays(in: .aboveRoads) ?? [])
        filteredWorkouts = workouts.filter { showWorkout($0) }
        mapView?.addOverlays(filteredWorkouts, level: .aboveRoads)
        if let selectedWorkout, !filteredWorkouts.contains(selectedWorkout) {
            self.selectedWorkout = nil
        }
    }
    
    func showWorkout(_ workout: Workout) -> Bool {
        (selectedWorkout == nil || workout == selectedWorkout) &&
        (workoutType == nil || workoutType == workout.type) &&
        (workoutDate == nil || Calendar.current.isDate(workout.date, equalTo: .now, toGranularity: workoutDate!.granularity))
    }
    
    func selectClosestWorkout(to targetCoord: CLLocationCoordinate2D) {
        let targetLocation = targetCoord.location
        var shortestDistance = Double.infinity
        var closestWorkout: Workout?
        
        guard let rect = mapView?.visibleMapRect else { return }
        let left = MKMapPoint(x: rect.minX, y: rect.midY)
        let right = MKMapPoint(x: rect.maxX, y: rect.midY)
        let maxDelta = left.distance(to: right) / 20
        
        for workout in filteredWorkouts {
            for location in workout.locations {
                let delta = location.distance(from: targetLocation)
                
                if delta < shortestDistance && delta < maxDelta {
                    shortestDistance = delta
                    closestWorkout = workout
                }
            }
        }
        selectWorkout(closestWorkout)
    }
    
    func selectWorkout(_ workout: Workout?) {
        selectedWorkout = workout
        if let workout {
            zoomTo(workout)
        }
    }
    
    func zoomTo(_ overlay: MKOverlay) {
        var bottomPadding = 20.0
        if selectedWorkout != nil {
            bottomPadding += 160
        }
        if recording {
            bottomPadding += 160
        }
        let padding = UIEdgeInsets(top: 20, left: 20, bottom: bottomPadding, right: 20)
        mapView?.setVisibleMapRect(overlay.boundingMapRect, edgePadding: padding, animated: true)
    }
    
    // MARK: - Workout Tracking
    func startWorkout(type: HKWorkoutActivityType) async {
        updateHealthStatus()
        guard healthAuth else { return }
        
        let config = HKWorkoutConfiguration()
        config.activityType = type
        config.locationType = .outdoor
        self.type = WorkoutType(hkType: type)
        
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
        
        Haptics.success()
        startDate = .now
        recording = true
        timer = Timer.publish(every: 0.5, on: .main, in: .default).autoconnect().sink { _ in
            self.pulse.toggle()
        }
    }
    
    func discardWorkout() {
        locationManager.allowsBackgroundLocationUpdates = false
        
        timer?.cancel()
        recording = false
        
        metres = 0
        locations = []
        updatePolylines()
        
        workoutBuilder?.discardWorkout()
        routeBuilder?.discard()
        Haptics.success()
    }
    
    func endWorkout() async {
        locationManager.allowsBackgroundLocationUpdates = false
        
        timer?.cancel()
        recording = false
        
        let workout = newWorkout
        workouts.append(workout)
        updatePolylines()
        filterWorkouts()
        selectWorkout(workout)
        
        metres = 0
        locations = []
        
        do {
            try await workoutBuilder?.endCollection(at: .now)
            if let workout = try await workoutBuilder?.finishWorkout() {
                try await routeBuilder?.finishRoute(with: workout, metadata: nil)
            }
            Haptics.success()
        } catch {
            showError(.endingWorkout)
        }
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
                withAnimation(.easeInOut(duration: 0.25)) {
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
            withAnimation(.easeInOut(duration: 0.25)) {
                self.degrees += 90
            }
        }
    }
    
    func updatePolylines() {
        mapView?.removeOverlays(mapView?.overlays(in: .aboveLabels) ?? [])
        mapView?.addOverlay(polyline, level: .aboveLabels)
        if let selectedWorkout {
            mapView?.addOverlay(selectedWorkout.polyline, level: .aboveLabels)
        }
    }
    
    @objc func handleTap(tap: UITapGestureRecognizer) {
        guard let mapView = mapView else { return }
        let tapPoint = tap.location(in: mapView)
        let tapCoord = mapView.convert(tapPoint, toCoordinateFrom: mapView)
        selectClosestWorkout(to: tapCoord)
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard recording else { return }
        
        let filteredLocations = locations.filter { location in
            location.horizontalAccuracy < 50
        }

        for location in filteredLocations {
            if let lastLocation = self.locations.last {
                metres += location.distance(from: lastLocation)
            }
            self.locations.append(location)
        }
        
        updatePolylines()
        
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
        accuracyAuth = manager.accuracyAuthorization == .fullAccuracy
        if !accuracyAuth {
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
            render.strokeColor = UIColor(polyline == selectedWorkout?.polyline ? .orange : .indigo)
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: false)
    }
}
