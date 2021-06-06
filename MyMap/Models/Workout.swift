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

struct Workout {
    let workout: HKWorkout
    let workoutType: HKWorkoutActivityType
    let routeLocations: [CLLocation]
    let routeMultiPolyline: MKMultiPolyline
    let date: Date?
    let distance: Double?
    let duration: Double
    let elevation: Double?
    let calories: Double?
}
