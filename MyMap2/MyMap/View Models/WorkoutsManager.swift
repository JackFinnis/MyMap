//
//  WorkoutsManager.swift
//  MyMap
//
//  Created by Finnis on 06/06/2021.
//

import Foundation
import MapKit
import HealthKit

class WorkoutsManager: NSObject, ObservableObject {
    // MARK: - Workouts from Health Store
    @Published var selectedIndex: Int = 0
    var selectedWorkout: Workout? {
        if workouts.count <= selectedIndex {
            return nil
        } else {
            return workouts[selectedIndex]
        }
    }
    
    @Published var workouts: [Workout] = []
    @Published var finishedLoading: Bool = false
    
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
    @Published var sortBy: WorkoutsSortBy = .recent
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
            case .recent:
                if workout1.date == nil || workout2.date == nil {
                    return true
                }
                return workout1.date! > workout2.date!
            case .oldest:
                if workout1.date == nil || workout2.date == nil {
                    return true
                }
                return workout1.date! < workout2.date!
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
            case .fewestCalories:
                if workout1.calories == nil || workout2.calories == nil {
                    return true
                }
                return workout1.calories! < workout2.calories!
            case .mostCalories:
                if workout1.calories == nil || workout2.calories == nil {
                    return true
                }
                return workout1.calories! > workout2.calories!
            case .leastElevation:
                if workout1.elevation == nil || workout2.elevation == nil {
                    return true
                }
                return workout1.elevation! < workout2.elevation!
            case .greatestElevation:
                if workout1.elevation == nil || workout2.elevation == nil {
                    return true
                }
                return workout1.elevation! < workout2.elevation!
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
    
    // MARK: - Initialiser
    override init() {
        super.init()
        // Setup HealthKit
        HealthKitSetupAssistant().requestAuthorisation()
        // Load Health Store Workouts
        loadWorkoutsData()
    }
    
    // MARK: - Map Helper Methods
    // Highlight to next workout
    public func nextWorkout() {
        if workouts.isEmpty || workouts.count == selectedIndex + 1 {
            selectedIndex = 0
        } else {
            selectedIndex += 1
        }
    }
    
    // Highlight to previous workout
    public func previousWorkout() {
        if workouts.isEmpty {
            selectedIndex = 0
        } else if selectedIndex == 0 {
            selectedIndex = workouts.count
        } else {
            selectedIndex += 1
        }
    }
    
    // Find the closest filtered route to the center coordinate
    public func getClosestRoute(center: CLLocationCoordinate2D) -> MKMultiPolyline {
        let centerCoordinate = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        var minimumDistance: Double = .greatestFiniteMagnitude
        var closestWorkout: Workout?
        
        for workout in filteredWorkouts {
            for location in workout.routeLocations {
                let delta = location.distance(from: centerCoordinate)
                if delta < minimumDistance {
                    minimumDistance = delta
                    closestWorkout = workout
                }
            }
        }
        
        if closestWorkout == nil {
            return MKMultiPolyline()
        }
        return MKMultiPolyline(closestWorkout!.routePolylines)
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
        let workoutDataStore = WorkoutDataStore()
        // Load array of workouts from health store
        workoutDataStore.loadWorkouts { (workouts, error) in
            if error == true || workouts!.isEmpty {
                print("No Workouts Returned by Health Store")
                DispatchQueue.main.async {
                    self.finishedLoading = true
                }
                return
            }
            // Load each workout route's data
            for workout in workouts! {
                workoutDataStore.loadWorkoutRoute(workout: workout) { (locations, formattedLocations, error) in
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