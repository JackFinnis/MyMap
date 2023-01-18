//
//  WorkoutView.swift
//  MyMap
//
//  Created by Finnis on 13/02/2021.
//

import SwiftUI
import CoreLocation

struct RootView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var vm = ViewModel()
    @AppStorage("launchedBefore") var launchedBefore = false
    @State var welcome = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapView()
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                Spacer()
                if let workout = vm.selectedWorkout {
                    WorkoutBar(workout: workout, new: false)
                }
                FloatingButtons()
                if vm.recording {
                    WorkoutBar(workout: vm.newWorkout, new: true)
                }
            }
            .padding(10)
        }
        .animation(.default, value: vm.recording)
        .animation(.default, value: vm.selectedWorkout)
        .alert(vm.error.rawValue, isPresented: $vm.showErrorAlert) {} message: {
            Text(vm.error.message)
        }
        .onAppear {
            if !launchedBefore {
                launchedBefore = true
                welcome = true
                vm.showInfoView = true
            }
        }
        .sheet(isPresented: $vm.showInfoView, onDismiss: {
            welcome = false
        }) {
            InfoView(welcome: welcome)
        }
        .sheet(isPresented: $vm.showPermissionsView) {
            PermissionsView()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                vm.updateHealthStatus()
            }
        }
        .environmentObject(vm)
    }
}
