//
//  FloatingMapButtons.swift
//  MyMap
//
//  Created by Finnis on 25/04/2021.
//

import SwiftUI
import MapKit
import HealthKit

struct FloatingButtons: View {
    @EnvironmentObject var vm: ViewModel
    @State var showWorkoutTypeChoice = false
    @State var showStopConfirmation = false
    @State var showFilterView = false
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                updateTrackingMode()
            } label: {
                Image(systemName: trackingModeImage)
                    .frame(width: SIZE, height: SIZE)
                    .scaleEffect(vm.scale)
            }
            Divider().frame(height: SIZE)
            
            Button {
                updateMapType()
            } label: {
                Image(systemName: mapTypeImage)
                    .frame(width: SIZE, height: SIZE)
                    .rotation3DEffect(.degrees(vm.mapType == .standard ? 0 : 180), axis: (x: 0, y: 1, z: 0))
                    .rotation3DEffect(.degrees(vm.degrees), axis: (x: 0, y: 1, z: 0))
            }
            Divider().frame(height: SIZE)
            
            if vm.loadingWorkouts {
                ProgressView()
                    .frame(width: SIZE, height: SIZE)
            } else if vm.workouts.isNotEmpty {
                Button {
                    showFilterView = true
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .frame(width: SIZE, height: SIZE)
                }
                .sheet(isPresented: $showFilterView) {
                    FilterView()
                        .font(nil)
                }
            }
            Divider().frame(height: SIZE)
            
            if vm.recording {
                Button {
                    showStopConfirmation = true
                } label: {
                    Image(systemName: "stop.fill")
                        .frame(width: SIZE, height: SIZE)
                }
                .confirmationDialog("Finish Workout?", isPresented: $showStopConfirmation, titleVisibility: .visible) {
                    Button("Cancel", role: .cancel) {}
                    Button("Finish") {
                        Task {
                            await vm.endWorkout()
                        }
                    }
                }
            } else {
                Button {
                    showWorkoutTypeChoice = true
                } label: {
                    Image(systemName: "record.circle")
                        .frame(width: SIZE, height: SIZE)
                }
                .confirmationDialog("Record a Workout", isPresented: $showWorkoutTypeChoice, titleVisibility: .visible) {
                    Button("Cancel", role: .cancel) {}
                    ForEach(WorkoutType.allCases, id: \.self) { type in
                        Button(type.rawValue) {
                            Task {
                                await vm.startWorkout(type: type.hkType)
                            }
                        }
                    }
                }
            }
            Divider().frame(height: SIZE)
            
            Button {
                vm.showInfoView = true
            } label: {
                Image(systemName: "info.circle")
                    .frame(width: SIZE, height: SIZE)
            }
        }
        .font(.system(size: SIZE/2))
        .materialBackground()
    }
    
    func updateTrackingMode() {
        var mode: MKUserTrackingMode {
            switch vm.mapView?.userTrackingMode ?? .none {
            case .none:
                return .follow
            case .follow:
                return .followWithHeading
            default:
                return .none
            }
        }
        vm.updateTrackingMode(mode)
    }
    
    func updateMapType() {
        var type: MKMapType {
            switch vm.mapView?.mapType ?? .standard {
            case .standard:
                return .hybrid
            default:
                return .standard
            }
        }
        vm.updateMapType(type)
    }
    
    var trackingModeImage: String {
        switch vm.trackingMode {
        case .none:
            return "location"
        case .follow:
            return "location.fill"
        default:
            return "location.north.line.fill"
        }
    }
    
    var mapTypeImage: String {
        switch vm.mapType {
        case .standard:
            return "globe.europe.africa.fill"
        default:
            return "map"
        }
    }
}
