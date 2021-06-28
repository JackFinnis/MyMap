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
    @Published var filteredWorkoutsCount: Int = 0
    @Published var selectedWorkout: Workout?
    @Published var finishedLoading: Bool = false
    
    // MARK: - Workout Filters
    @Published var sortBy: WorkoutsSortBy = .recent  { didSet { updateWorkoutFilters() } }
    @Published var numberShown: WorkoutsShown = .all  { didSet { updateWorkoutFilters() } }
    
    @Published var distanceFilter = WorkoutFilter(type: .distance) { didSet { updateWorkoutFilters() } }
    @Published var durationFilter = WorkoutFilter(type: .duration) { didSet { updateWorkoutFilters() } }
    @Published var caloriesFilter = WorkoutFilter(type: .calories) { didSet { updateWorkoutFilters() } }
    
    @Published var filterByType: Bool = false { didSet { updateWorkoutFilters() } }
    @Published var displayWalks: Bool = true { didSet { updateWorkoutFilters() } }
    @Published var displayRuns: Bool = true { didSet { updateWorkoutFilters() } }
    @Published var displayCycles: Bool = true { didSet { updateWorkoutFilters() } }
    @Published var displayOther: Bool = true { didSet { updateWorkoutFilters() } }
    
    @Published var filterByDate: Bool = false { didSet { updateWorkoutFilters() } }
    @Published var startDate: Date = Date() { didSet { updateWorkoutFilters() } }
    @Published var endDate: Date = Date() { didSet { updateWorkoutFilters() } }
    
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
        selectedWorkout = filteredWorkouts.first
        setSelectedColour()
    }
    
    // Reset selected workout polyline colour
    private func resetSelectedColour() {
        selectedWorkout?.routePolylines.first?.selected = false
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    // Set selected workout polyline colour
    private func setSelectedColour() {
        selectedWorkout?.routePolylines.first?.selected = true
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
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
        // Filter and sort workouts
        let filtered = filterWorkouts(workouts: workouts)
        let sorted = sortWorkouts(workouts: filtered)
        let numberFiltered = filterNumber(workouts: sorted)
        
        // Update published
        DispatchQueue.main.async {
            self.filteredWorkouts = numberFiltered
            self.filteredWorkoutsCount = sorted.count
            self.selectFirstWorkout()
        }
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
                if distanceFilter.minimum < distanceFilter.maximum && workout.distance! >= distanceFilter.maximum * 1000 {
                    return false
                }
            }
            // Filter by duration
            if durationFilter.filter {
                if workout.duration <= durationFilter.minimum {
                    return false
                }
                if durationFilter.minimum < durationFilter.maximum && workout.duration >= durationFilter.maximum * 60 {
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
                if startDate < endDate && workout.date! >= endDate {
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
                if caloriesFilter.minimum < caloriesFilter.maximum && workout.calories! >= caloriesFilter.maximum {
                    return false
                }
            }
            // Filter sort by
            switch sortBy {
            case .recent:
                if workout.date == nil || workout.date == nil {
                    return false
                }
            case .oldest:
                if workout.date == nil || workout.date == nil {
                    return false
                }
            case .shortestDistance:
                if workout.distance == nil || workout.distance == nil {
                    return false
                }
            case .longestDistance:
                if workout.distance == nil || workout.distance == nil {
                    return false
                }
            case .fewestCalories:
                if workout.calories == nil || workout.calories == nil {
                    return false
                }
            case .mostCalories:
                if workout.calories == nil || workout.calories == nil {
                    return false
                }
            default:
                return true
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
                    return false
                }
                return workout1.date! > workout2.date!
            case .oldest:
                if workout1.date == nil || workout2.date == nil {
                    return false
                }
                return workout1.date! < workout2.date!
            case .shortestDistance:
                if workout1.distance == nil || workout2.distance == nil {
                    return false
                }
                return workout1.distance! < workout2.distance!
            case .longestDistance:
                if workout1.distance == nil || workout2.distance == nil {
                    return false
                }
                return workout1.distance! > workout2.distance!
            case .shortestDuration:
                return workout1.duration < workout2.duration
            case .longestDuration:
                return workout1.duration > workout2.duration
            case .fewestCalories:
                if workout1.calories == nil || workout2.calories == nil {
                    return false
                }
                return workout1.calories! < workout2.calories!
            case .mostCalories:
                if workout1.calories == nil || workout2.calories == nil {
                    return false
                }
                return workout1.calories! > workout2.calories!
            }
        }
    }
    
    // Filter the number of workouts
    private func filterNumber(workouts: [Workout]) -> [Workout] {
        switch numberShown {
        case .none:
            return []
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
        case .all:
            return workouts
        }
    }
    
    // MARK: - String Formatting
    // Selected workout strings
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
    
    // Filter summaries
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
    var dateFilterSummary: String {
        if !filterByDate {
            return ""
        } else if startDate >= endDate {
            return "\(formatDate(date: startDate)) onwards"
        } else {
            return "\(formatDate(date: startDate)) to \(formatDate(date: endDate))"
        }
    }
    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: date)
    }
}
