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
    @State var showWelcomeView = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapView()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                FloatingButtons()
                if let workout = vm.selectedWorkout {
                    WorkoutBar(workout: workout)
                }
                if vm.recording {
                    NewWorkoutBar()
                }
            }
        }
        .environmentObject(vm)
        .alert(vm.error.rawValue, isPresented: $vm.showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(vm.error.message)
        }
        .onAppear {
            if !launchedBefore {
                launchedBefore = true
                showWelcomeView = true
            }
        }
        .sheet(isPresented: $showWelcomeView) {
            InfoView(firstLaunch: true)
        }
        .sheet(isPresented: $vm.showPermissionsView) {
            PermissionsView()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                vm.updateHealthStatus()
            }
        }
    }
}
