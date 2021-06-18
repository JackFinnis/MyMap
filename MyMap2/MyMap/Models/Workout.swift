//
//  Workout.swift
//  MyMap
//
//  Created by Finnis on 15/05/2021.
//

import Foundation
import HealthKit
import MapKit
import CoreLocation

struct Workout: Equatable {
    let workout: HKWorkout
    let workoutType: HKWorkoutActivityType
    let routeLocations: [CLLocation]
    let routePolylines: [MulticolourPolyline]
    let date: Date?
    let distance: Double?
    let duration: Double
    let elevation: Double?
    let calories: Double?
    
    var workoutTypeString: String {
        switch workoutType {
        case .running:
            return "Running"
        case .walking:
            return "Walking"
        case .cycling:
            return "Walking"
        default:
            return "Other"
        }
    }
    var durationString: String {
        String(format: "%02d:%02d", Int(duration) / 60, Int(duration) % 60)
    }
    
    var dateString: String {
        if date == nil {
            return ""
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: date!)
        }
    }
    var distanceString: String {
        if distance == nil {
            return ""
        } else {
            return "\(Int(distance!) / 1000).\(Int(distance!) % 1000) km"
        }
    }
    var elevationString: String {
        if elevation == nil {
            return ""
        } else {
            return "\(Int(elevation!)) m"
        }
    }
    var caloriesString: String {
        if calories == nil {
            return ""
        } else {
            return "\(Int(calories!)) cal"
        }
    }
}
