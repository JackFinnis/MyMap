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
    let locations: [CLLocation]
    let date: Date
    let duration: Double
    let distance: Double
    let elevation: Double
    
    init(type: WorkoutType, polyline: MKPolyline, locations: [CLLocation], date: Date, duration: Double) {
        self.type = type
        self.polyline = polyline
        self.locations = locations
        self.date = date
        self.duration = duration
        self.distance = locations.distance
        self.elevation = locations.elevation
    }
    
    convenience init(hkWorkout: HKWorkout, locations: [CLLocation]) {
        let coords = locations.map(\.coordinate)
        let type = WorkoutType(hkType: hkWorkout.workoutActivityType)
        let polyline = MKPolyline(coordinates: coords, count: coords.count)
        let date = hkWorkout.startDate
        let duration = hkWorkout.duration
        self.init(type: type, polyline: polyline, locations: locations, date: date, duration: duration)
    }
    
    static let example = Workout(type: .walk, polyline: MKPolyline(), locations: [], date: .now, duration: 3456)
}

extension Workout: MKOverlay {
    var coordinate: CLLocationCoordinate2D {
        polyline.coordinate
    }
    
    var boundingMapRect: MKMapRect {
        polyline.boundingMapRect
    }
}
