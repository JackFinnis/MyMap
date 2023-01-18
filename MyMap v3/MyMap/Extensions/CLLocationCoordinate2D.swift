//
//  CLLocationCoordinate2D.swift
//  MyMap
//
//  Created by Jack Finnis on 11/01/2023.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}
