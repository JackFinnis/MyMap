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
    let routeLocations: [CLLocation]
    let routePolyline: MKPolyline
}
