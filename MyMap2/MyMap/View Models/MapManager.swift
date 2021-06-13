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
    @Published var searchState: WorkoutSearchState = .found
    
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
        case .found:
            return "xmark"
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
    
    // Workout search button pressed
    public func updateSearchState() {
        switch searchState {
        case .none:
            searchState = .finding
        case .finding:
            searchState = .found
        case .found:
            searchState = .none
        }
    }
    
    // Map yype button pressed
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
    // Render multi polyline overlays
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
