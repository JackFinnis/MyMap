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
    // MARK: - Workouts
    @Published var workouts: [Workout] = []
    @Published var filteredWorkouts: [Workout] = []
    @Published var selectedWorkout: Workout?
    @Published var finishedLoading: Bool = false
    var selectedWorkoutDurationString: String {
        if selectedWorkout == nil {
            return ""
        } else {
            return selectedWorkout!.durationString
        }
    }
    var selectedWorkoutDistanceString: String {
        if selectedWorkout == nil {
            return ""
        } else {
            return selectedWorkout!.distanceString
        }
    }
    
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
    
    // MARK: - Initialiser
    override init() {
        super.init()
        // Load Health Store Workouts
        loadHealthKitWorkouts()
    }
    
    // MARK: - Private functions
    // Load HealthKit workouts
    private func loadHealthKitWorkouts() {
        // Use workout data store
        let healthKitDataStore = HealthKitDataStore()
        healthKitDataStore.loadAllWorkouts { (workouts) in
            // Update published properties
            DispatchQueue.main.async {
                self.workouts = workouts
                self.updateWorkoutFilters()
                self.finishedLoading = true
            }
        }
    }
    
    // MARK: - Public Functions
    // Find the closest filtered route to the center coordinate
    public func setClosestRoute(center: CLLocationCoordinate2D) {
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
        
        DispatchQueue.main.async {
            self.resetSelectedColour()
            self.selectedWorkout = closestWorkout
            self.setSelectedColour()
        }
    }
    
    // Return the filtered workouts multi polyline
    public func getFilteredWorkoutsMultiPolyline() -> [MulticolourPolyline] {
        var polylines: [MulticolourPolyline] = []
        
        for workout in filteredWorkouts {
            polylines.append(contentsOf: workout.routePolylines)
        }
        
        return polylines
    }
    
    // MARK: - Selected Workout
    // Select the first filtered workout to highlight
    public func selectFirstWorkout() {
        // Reset selected colour
        resetSelectedColour()
        if filteredWorkouts.isEmpty {
            selectedWorkout = nil
        } else {
            selectedWorkout = filteredWorkouts.first
        }
        setSelectedColour()
    }
    
    // Reset selected workout polyline colour
    private func resetSelectedColour() {
        selectedWorkout?.routePolylines.first?.selected = false
        self.objectWillChange.send()
    }
    
    // Set selected workout polyline colour
    private func setSelectedColour() {
        selectedWorkout?.routePolylines.first?.selected = true
        self.objectWillChange.send()
    }
    
    // Highlight next workout
    public func nextWorkout() {
        // Reset selected colour
        resetSelectedColour()
        if filteredWorkouts.isEmpty {
            selectedWorkout = nil
        } else if selectedWorkout == nil {
            selectedWorkout = filteredWorkouts.first
        } else {
            let index = filteredWorkouts.firstIndex(of: selectedWorkout!)
            if index == nil {
                selectedWorkout = filteredWorkouts.first
            } else {
                if index == filteredWorkouts.count-1 {
                    selectedWorkout = filteredWorkouts.first
                } else {
                    selectedWorkout = filteredWorkouts[index!+1]
                }
            }
        }
        setSelectedColour()
    }
    
    // Highlight previous workout
    public func previousWorkout() {
        // Reset selected colour
        resetSelectedColour()
        if filteredWorkouts.isEmpty {
            selectedWorkout = nil
        } else if selectedWorkout == nil {
            selectedWorkout = filteredWorkouts.first
        } else {
            let index = filteredWorkouts.firstIndex(of: selectedWorkout!)
            if index == nil {
                selectedWorkout = filteredWorkouts.first
            } else {
                if index == 0 {
                    selectedWorkout = filteredWorkouts.last
                } else {
                    selectedWorkout = filteredWorkouts[index!-1]
                }
            }
        }
        setSelectedColour()
    }
    
    // MARK: - Filter workouts
    // Update workout filters
    public func updateWorkoutFilters() {
        // Only calculate if workouts need to be shown
        if !showWorkouts {
            DispatchQueue.main.async {
                self.filteredWorkouts = []
            }
            return
        }
        
        // Filter and sort workouts
        let filtered = filterWorkouts(workouts: workouts)
        let sorted = sortWorkouts(workouts: filtered)
        let numberFiltered = filterNumber(workouts: sorted)
        
        // Update published
        DispatchQueue.main.async {
            self.filteredWorkouts = numberFiltered
        }
        
        // Select first workout to highlight
        selectFirstWorkout()
    }
    
    // Filter workouts
    private func filterWorkouts(workouts: [Workout]) -> [Workout] {
        // Filter workouts
        workouts.filter { workout in
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
    }
    
    // Filter and sort all workouts based on previous properties
    private func sortWorkouts(workouts: [Workout]) -> [Workout] {
        // Sort workouts
        workouts.sorted { (workout1, workout2) in
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
    }
    
    // Filter the number of workouts
    private func filterNumber(workouts: [Workout]) -> [Workout] {
        switch numberShown {
        case .five:
            if workouts.count < 5 {
                return workouts
            } else {
                return Array(workouts[..<5])
            }
        case .ten:
            if workouts.count < 10 {
                return workouts
            } else {
                return Array(workouts[..<10])
            }
        default:
            return workouts
        }
    }
}
