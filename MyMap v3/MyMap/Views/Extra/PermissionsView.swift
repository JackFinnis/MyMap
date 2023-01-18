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
                    HStack(spacing: 15) {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .frame(width: 45, height: 45)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(9)
                            .shadow(color: .black.opacity(0.2), radius: 5)
                        PermissionRow(title: "Location Always", description: NAME + " needs access to your location to record a workout route in the background.", allowed: vm.locationAuth, denied: vm.locationStatus == .denied, instructions: "Please go to Settings > Location and select \"Always\"", linkTitle: "Settings", linkString: UIApplication.openSettingsURLString) {
                            vm.requestLocationAuthorisation()
                        }
                    }
                }
                
                Section {
                    HStack(spacing: 15) {
                        Image("healthIcon")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 45, height: 45)
                            .cornerRadius(9)
                            .shadow(color: .black.opacity(0.2), radius: 5)
                        PermissionRow(title: "Health", description: NAME + " needs access to your Health Data to show all your workout routes on one map.", allowed: vm.healthAuth, denied: vm.healthStatus == .sharingDenied, instructions: "Please go to Health > Sharing > Apps > \(NAME) and select \"Turn On All\"", linkTitle: "Health", linkString: "x-apple-health://") {
                            vm.requestLocationAuthorisation()
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
    let request: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            Text(description)
                .foregroundColor(.secondary)
                .font(.subheadline)
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
        .alert("Allow Access", isPresented: $showAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Open " + linkTitle) {
                if let url = URL(string: linkString) {
                    UIApplication.shared.open(url)
                }
            }
        } message: {
            Text(instructions)
        }
    }
}
