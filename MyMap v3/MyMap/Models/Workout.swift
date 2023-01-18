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

class Workout: NSObject {
    let type: WorkoutType
    let polyline: MKPolyline
    let date: Date
    let seconds: Double
    let metres: Double?
    let calories: Double?
    
    init(type: WorkoutType, polyline: MKPolyline, date: Date, seconds: Double, meters: Double?, calories: Double?) {
        self.type = type
        self.polyline = polyline
        self.date = date
        self.seconds = seconds
        self.metres = meters
        self.calories = calories
    }
    
    convenience init(hkWorkout: HKWorkout, locations: [CLLocation]) {
        let coords = locations.map(\.coordinate)
        let type = WorkoutType(hkType: hkWorkout.workoutActivityType)
        let polyline = MKPolyline(coordinates: coords, count: coords.count)
        let date = hkWorkout.startDate
        let seconds = hkWorkout.duration
        let metres = hkWorkout.totalDistance?.doubleValue(for: HKUnit.meter())
        let calories = hkWorkout.totalEnergyBurned?.doubleValue(for: HKUnit.kilocalorie())
        self.init(type: type, polyline: polyline, date: date, seconds: seconds, meters: metres, calories: calories)
    }
}

extension Workout: MKOverlay {
    var coordinate: CLLocationCoordinate2D {
        polyline.coordinate
    }
    var boundingMapRect: MKMapRect {
        polyline.boundingMapRect
    }
}
