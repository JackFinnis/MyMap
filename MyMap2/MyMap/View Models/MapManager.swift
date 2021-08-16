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
    @Published var userTrackingMode: MKUserTrackingMode = .none
    @Published var mapType: MKMapType = .standard
    @Published var searchState: WorkoutSearchState = .none
    @Published var loadedMap: Bool = false
    
    var parent: MapView?
    var selectedWorkout: Workout?
    
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
    
    // Map type button pressed
    public func updateMapType() {
        switch mapType {
        case .standard:
            mapType = .hybrid
        default:
            mapType = .standard
        }
    }
    
    // Get map region
    public func getSelectedWorkoutRegion() -> MKCoordinateRegion? {
        if selectedWorkout == nil {
            return nil
        } else if selectedWorkout!.routeLocations.isEmpty {
            return nil
        }
        
        var minLat: Double = 90
        var maxLat: Double = -90
        var minLong: Double = 180
        var maxLong: Double = -180
        
        for location in selectedWorkout!.routeLocations {
            if location.coordinate.latitude < minLat {
                minLat = location.coordinate.latitude
            }
            if location.coordinate.latitude > maxLat {
                maxLat = location.coordinate.latitude
            }
            if location.coordinate.longitude < minLong {
                minLong = location.coordinate.longitude
            }
            if location.coordinate.longitude > maxLong {
                maxLong = location.coordinate.longitude
            }
        }
        
        let latDelta: Double = maxLat - minLat
        let longDelta: Double = maxLong - minLong
        let span = MKCoordinateSpan(latitudeDelta: latDelta * 1.4, longitudeDelta: longDelta * 1.4)
        let centre = CLLocationCoordinate2D(latitude: (minLat + maxLat)/2, longitude: (minLong + maxLong)/2)
        let region = MKCoordinateRegion(center: centre, span: span)
        return region
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
            if polyline.pointCount == selectedWorkout?.routePolylines.first?.pointCount {
                return .systemOrange
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
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        if loadedMap != true {
            loadedMap = true
            userTrackingMode = .follow
        }
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        if !animated {
            userTrackingMode = .none
        }
    }
}
