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
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: TimeInterval(duration))!
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
            return String(format: "%.2f km", distance! / 1000)
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
