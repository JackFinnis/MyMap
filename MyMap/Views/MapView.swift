//
//  MapView.swift
//  MyMap
//
//  Created by Finnis on 14/02/2021.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    var mapView = MKMapView()
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        // Set coordinator
        mapView.delegate = context.coordinator
        
        // Show user location, map scale and compass
        mapView.showsUserLocation = true
        mapView.showsScale = true
        mapView.showsCompass = true
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Update view
    }
}
