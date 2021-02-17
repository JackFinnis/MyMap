//
//  MapCoordinator.swift
//  MyMap
//
//  Created by Finnis on 16/02/2021.
//

import Foundation
import MapKit

class MapCoordinator: NSObject, MKMapViewDelegate {
    
    var parent: MapView
    
    init(_ parent: MapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        guard let polyline = overlay as? MKPolyline else {
          return MKOverlayRenderer(overlay: overlay)
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
}
