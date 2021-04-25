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
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
    
    // MARK: - Map View Delegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        guard let multiPolyline = overlay as? MKMultiPolyline else {
          return MKOverlayRenderer(overlay: overlay)
        }
        
        let renderer = MKMultiPolylineRenderer(multiPolyline: multiPolyline)
        renderer.strokeColor = .red
        renderer.lineWidth = 3
        return renderer
    }
}
