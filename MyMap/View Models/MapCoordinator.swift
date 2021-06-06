//
//  MapCoordinator.swift
//  MyMap
//
//  Created by Finnis on 16/02/2021.
//

import Foundation
import MapKit

class MapCoordinator: NSObject, MKMapViewDelegate {
    // MARK: - Properties
    let parent: MapView
    
    // MARK: - Initialiser
    init(_ parent: MapView) {
        self.parent = parent
    }
    
    // MARK: - MKMapView Delegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let multiPolyline = overlay as? MKMultiPolyline else {
          return MKOverlayRenderer(overlay: overlay)
        }
        
        let renderer = MKMultiPolylineRenderer(multiPolyline: multiPolyline)
        renderer.strokeColor = UIColor(.accentColor)
        renderer.lineWidth = 3
        return renderer
    }
}
