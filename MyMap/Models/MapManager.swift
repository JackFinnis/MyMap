//
//  MapManager.swift
//  MyMap
//
//  Created by Finnis on 15/02/2021.
//

import Foundation
import CoreLocation

class MapManager: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    // Track user immediately
    override init() {
        super.init()
        
        // Create the location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        // Request location services authorisation
        locationManager.requestWhenInUseAuthorization()
        
        // Start tracking the user
        locationManager.startUpdatingLocation()
    }
}
