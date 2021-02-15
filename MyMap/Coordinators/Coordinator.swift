//
//  Coordinator.swift
//  MyMap
//
//  Created by Finnis on 15/02/2021.
//

import Foundation
import MapKit

class Coordinator: NSObject, MKMapViewDelegate {
    
    var parent: MapView
    
    init(_ parent: MapView) {
        self.parent = parent
    }
}
