//
//  MapManager.swift
//  MyMap
//
//  Created by Finnis on 06/06/2021.
//

import Foundation
import MapKit

class MapManager: NSObject, ObservableObject {
    // MARK: - Properties
    @Published var userTrackingMode: MKUserTrackingMode = .follow
    @Published var mapType: MKMapType = .standard
    @Published var searchState: WorkoutSearchState = .none
    
    var parent: MapView?
    
    // Display image names
    public var userTrackingModeImageName: String {
        switch userTrackingMode {
        case .none:
            return "location"
        case .follow:
            return "location.fill"
        default:
            return "location.north.line.fill"
        }
    }
    
    public var searchStateImageName: String {
        switch searchState {
        case .none:
            return "magnifyingglass"
        case .finding:
            return "mappin.and.ellipse"
        }
    }
    
    public var mapTypeImageName: String {
        switch mapType {
        case .standard:
            return "globe"
        default:
            return "map"
        }
    }
    
    // MARK: - Map Settings Update Methods
    // User tracking mode button pressed
    public func updateUserTrackingMode() {
        switch userTrackingMode {
        case .none:
            userTrackingMode = .follow
        case .follow:
            userTrackingMode = .followWithHeading
        default:
            userTrackingMode = .none
        }
    }
    
    // Map type button pressed
    public func updateMapType() {
        switch mapType {
        case .standard:
            mapType = .hybrid
        default:
            mapType = .standard
        }
    }
}

// MARK: - MKMapView Delegate
extension MapManager: MKMapViewDelegate {
    // Render multicolour polyline overlays
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MulticolourPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        
        // Set different colour if selected
        var colour: UIColor {
            if polyline.selected {
                return .systemYellow
            } else {
                return polyline.colour!
            }
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = colour
        renderer.lineWidth = 2
        return renderer
    }
    
    // Update parent centre coordinate
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        DispatchQueue.main.async {
            self.parent?.centreCoordinate = mapView.centerCoordinate
        }
    }
}
