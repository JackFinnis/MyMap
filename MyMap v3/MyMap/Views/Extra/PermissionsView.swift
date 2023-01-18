//
//  PermissionsView.swift
//  MyMap
//
//  Created by Jack Finnis on 17/01/2023.
//

import SwiftUI

struct PermissionsView: View {
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack(alignment: .top, spacing: 15) {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .frame(width: 50, height: 50)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.top, 10)
                        PermissionRow(title: "Location Always", description: NAME + " needs access to your location to record a workout route in the background and show your location on the map.", allowed: vm.locationAuth, denied: vm.locationStatus == .denied || vm.locationStatus == .authorizedWhenInUse, instructions: "Please go to Settings > \(NAME) > Location and select \"Always\"", linkTitle: "Settings", linkString: UIApplication.openSettingsURLString, loading: vm.locationLoading) {
                            vm.requestLocationAuthorisation()
                        }
                    }
                }
                
                Section {
                    HStack(alignment: .top, spacing: 15) {
                        Image("healthIcon")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.2), radius: 5)
                            .padding(.top, 10)
                        PermissionRow(title: "Health", description: NAME + " needs access to your Health Data to show all your workout routes on one map and save the workouts you record.", allowed: vm.healthAuth, denied: vm.healthStatus == .sharingDenied, instructions: "Please go to Health > Sharing > Apps > \(NAME) and select \"Turn On All\"", linkTitle: "Health", linkString: "x-apple-health://", loading: vm.healthLoading) {
                            Task {
                                await vm.requestHealthAuthorisation()
                            }
                        }
                    }
                }
            }
            .buttonStyle(.borderless)
            .navigationTitle("Need Permissions")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(alignment: .bottom) {
                Button {
                    vm.showPermissionsView = false
                } label: {
                    Text("Get Started")
                        .bigButton()
                }
                .padding()
                .disabled(!vm.healthAuth || !vm.locationAuth)
            }
        }
        .interactiveDismissDisabled()
    }
}

struct PermissionsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
            .sheet(isPresented: .constant(true)) {
                PermissionsView()
                    .environmentObject(ViewModel())
            }
    }
}

struct PermissionRow: View {
    @State var showAlert = false
    
    let title: String
    let description: String
    let allowed: Bool
    let denied: Bool
    let instructions: String
    let linkTitle: String
    let linkString: String
    let loading: Bool
    let request: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            Text(description)
                .foregroundColor(.secondary)
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)
            if loading {
                ProgressView()
                    .padding(.vertical, 5)
            } else {
                Button {
                    if denied {
                        showAlert = true
                    } else {
                        request()
                    }
                } label: {
                    Text(allowed ? "Allowed" : "Allow")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.accentColor)
                        .font(.headline)
                        .foregroundColor(.white)
                        .cornerRadius(.infinity)
                }
                .disabled(allowed)
            }
        }
        .padding(.vertical, 5)
        .alert("Allow Access", isPresented: $showAlert) {
            Button("Cancel") {}
            Button(linkTitle, role: .cancel) {
                if let url = URL(string: linkString) {
                    UIApplication.shared.open(url)
                }
            }
        } message: {
            Text(instructions)
        }
    }
}
