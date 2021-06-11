//
//  MapManager.swift
//  MyMap
//
//  Created by Finnis on 06/06/2021.
//

import Foundation
import MapKit
import HealthKit

class MapManager: NSObject, ObservableObject {
    // MARK: - Workouts from Health Store
    @Published var workouts: [Workout] = []
    @Published var finishedLoading: Bool = false
    
    private let workoutDataStore = WorkoutDataStore()
    
    // MARK: - Workout Filters
    @Published var distanceFilter = WorkoutFilter(type: .distance)
    @Published var durationFilter = WorkoutFilter(type: .duration)
    @Published var caloriesFilter = WorkoutFilter(type: .calories)
    @Published var elevationFilter = WorkoutFilter(type: .elevation)
    
    @Published var filterByType: Bool = false
    @Published var displayWalks: Bool = true
    @Published var displayRuns: Bool = true
    @Published var displayCycles: Bool = true
    @Published var displayOther: Bool = true
    var typeFilterSummary: String {
        if !filterByType {
            return ""
        }
        var typesShowing: [String] = []
        if displayRuns {
            typesShowing.append("Runs")
        }
        if displayWalks {
            typesShowing.append("Walks")
        }
        if displayCycles {
            typesShowing.append("Cycles")
        }
        if displayOther {
            typesShowing.append("Other")
        }
        return typesShowing.joined(separator: ", ")
    }
    
    @Published var filterByDate: Bool = false
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    var dateFilterSummary: String {
        if !filterByDate {
            return ""
        } else if startDate >= endDate {
            return "\(formatDate(date: startDate)) onwards"
        } else {
            return "\(formatDate(date: startDate)) to \(formatDate(date: endDate))"
        }
    }
    
    // Format date to dd/mm/yy
    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/mm/yy"
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Workout Sort Desciptors
    @Published var sortBy: WorkoutsSortBy = .endDate
    @Published var numberShown: WorkoutsShown = .none
    public var showWorkouts: Bool {
        if numberShown == .none {
            return false
        } else {
            return true
        }
    }
    
    // MARK: - Filtered workouts
    // Filter and sort all workouts based on previous properties
    public var filteredWorkouts: [Workout] {
        // Only calculate if workouts need to be shown
        if !showWorkouts {
            return []
        }
        
        // Filter workouts
        var filtered: [Workout] = workouts.filter { workout in
            // Filter by type
            if filterByType {
                switch workout.workoutType {
                case .walking:
                    if !displayWalks {
                        return false
                    }
                case .running:
                    if !displayRuns {
                        return false
                    }
                case .cycling:
                    if !displayCycles {
                        return false
                    }
                default:
                    if !displayOther {
                        return false
                    }
                }
            }
            // Filter by distance
            if distanceFilter.filter {
                if workout.distance == nil {
                    return false
                }
                if workout.distance! <= distanceFilter.minimum {
                    return false
                }
                if workout.distance! >= distanceFilter.maximum {
                    return false
                }
            }
            // Filter by duration
            if durationFilter.filter {
                if workout.duration <= durationFilter.minimum {
                    return false
                }
                if workout.duration >= durationFilter.maximum {
                    return false
                }
            }
            // Filter by date
            if filterByDate {
                if workout.date == nil {
                    return false
                }
                if workout.date! <= startDate {
                    return false
                }
                if workout.date! >= endDate {
                    return false
                }
            }
            // Filter by calories
            if caloriesFilter.filter {
                if workout.calories == nil {
                    return false
                }
                if workout.calories! <= caloriesFilter.minimum {
                    return false
                }
                if workout.calories! >= caloriesFilter.maximum {
                    return false
                }
            }
            // Filter by elevation
            if elevationFilter.filter {
                if workout.elevation == nil {
                    return false
                }
                if workout.elevation! <= elevationFilter.minimum {
                    return false
                }
                if workout.elevation! >= elevationFilter.maximum {
                    return false
                }
            }
            // Passed the filter criteria!
            return true
        }
        
        // Sort workouts
        filtered.sort { (workout1, workout2) in
            switch sortBy {
            case .startDate:
                if workout1.date == nil || workout2.date == nil {
                    return true
                }
                return workout1.date! < workout2.date!
            case .endDate:
                if workout1.date == nil || workout2.date == nil {
                    return true
                }
                return workout1.date! > workout2.date!
            case .shortestDistance:
                if workout1.distance == nil || workout2.distance == nil {
                    return true
                }
                return workout1.distance! < workout2.distance!
            case .longestDistance:
                if workout1.distance == nil || workout2.distance == nil {
                    return true
                }
                return workout1.distance! > workout2.distance!
            case .shortestDuration:
                return workout1.duration < workout2.duration
            case .longestDuration:
                return workout1.duration > workout2.duration
            }
        }
        
        // Filter the number of workouts
        switch numberShown {
        case .five:
            if filtered.count < 5 {
                return filtered
            } else {
                return Array(filtered[..<5])
            }
        case .ten:
            if filtered.count < 10 {
                return filtered
            } else {
                return Array(filtered[..<10])
            }
        default:
            return filtered
        }
    }
    
    // MARK: - Map Settings
    @Published var userTrackingMode: MKUserTrackingMode = .follow
    @Published var mapType: MKMapType = .standard
    @Published var searchState: WorkoutSearchState = .none
    
    public let mapTypeNames: [String] = ["Standard", "Satellite", "Hybrid"]
    public let mapTypes: [MKMapType] = [.standard, .satellite, .hybrid]
    
    // Display images
    public var userTrackingModeImageName: String {
        switch userTrackingMode {
        case .none:
            return "location"
        case .follow:
            return "location.fill"
        default:
            return "location.north.line.fill"
        }
    }
    
    public var searchStateImageName: String {
        switch searchState {
        case .none:
            return "magnifyingglass"
        case .finding:
            return "magnifyingglass"
        case .found:
            return "magnifyingglass"
        }
    }
    
    // MARK: - Initialiser
    override init() {
        super.init()
        // Setup HealthKit
        HealthKitSetupAssistant().requestAuthorisation()
        // Load Health Store Workouts
        loadWorkoutsData()
    }
    
    // MARK: - Map Settings Update Methods
    // User tracking mode button pressed
    public func updateUserTrackingMode() {
        switch userTrackingMode {
        case .none:
            userTrackingMode = .follow
        case .follow:
            userTrackingMode = .followWithHeading
        default:
            userTrackingMode = .none
        }
    }
    
    // Workout search button pressed
    public func updateSearchState() {
        switch searchState {
        case .none:
            searchState = .finding
        case .finding:
            searchState = .found
        case .found:
            searchState = .none
        }
    }
    
    // MARK: - Map Helper Methods
    // Find the closest filtered route to the center coordinate
    public func getClosestRoute(center: CLLocationCoordinate2D) -> MKMultiPolyline {
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
    
    // Return the filtered workouts multi polyline
    public func getFilteredWorkoutsMultiPolyline() -> MKMultiPolyline {
        var polylines: [MKPolyline] = []
        
        for workout in filteredWorkouts {
            polylines.append(contentsOf: workout.routePolylines)
        }
        
        return MKMultiPolyline(polylines)
    }
    
    // MARK: - Workouts Data Store Interface
    // Load all workouts and associated data
    public func loadWorkoutsData() {
        // Load array of workouts from health store
        workoutDataStore.loadWorkouts { (workouts, error) in
            if error == true {
                print("No Workouts Returned by Health Store")
                self.finishedLoading = true
                return
            }
            // Load each workout route's data
            for workout in workouts! {
                self.workoutDataStore.loadWorkoutRoute(workout: workout) { (locations, formattedLocations, error) in
                    if error == true {
                        // Workout has no route
                        return
                    }
                    
                    // Instantiate new workout
                    let newWorkout = Workout(
                        workout: workout,
                        workoutType: workout.workoutActivityType,
                        routeLocations: locations!,
                        routePolylines: [MKPolyline(coordinates: formattedLocations!, count: formattedLocations!.count)],
                        date: workout.startDate,
                        distance: workout.totalDistance?.doubleValue(for: HKUnit.meter()),
                        duration: workout.duration,
                        elevation: 0,
                        calories: workout.totalEnergyBurned?.doubleValue(for: HKUnit.smallCalorie())
                    )
                    
                    // Update published properties
                    DispatchQueue.main.async {
                        self.workouts.append(newWorkout)
                        if workout == workouts!.last {
                            self.finishedLoading = true
                        }
                    }
                }
            }
        }
    }
}

// MARK: - MKMapView Delegate
extension MapManager: MKMapViewDelegate {
    // Render multi polyline overlays
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let multiPolyline = overlay as? MKMultiPolyline else {
          return MKOverlayRenderer(overlay: overlay)
        }
        
        let renderer = MKMultiPolylineRenderer(multiPolyline: multiPolyline)
        renderer.strokeColor = UIColor(.accentColor)
        renderer.lineWidth = 3
        return renderer
    }
}
