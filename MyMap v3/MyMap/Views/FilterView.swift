//
//  SettingsView.swift
//  MyMap
//
//  Created by Jack Finnis on 18/01/2023.
//

import SwiftUI

struct FilterView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section("Type") {
                    Picker("Workout Type", selection: $vm.workoutType) {
                        ForEach(WorkoutType.allCases, id: \.self) { type in
                            if type != .other {
                                Text(type.rawValue + "s")
                                    .tag(type as WorkoutType?)
                            }
                        }
                        Text("All")
                            .tag(nil as WorkoutType?)
                    }
                    .pickerStyle(.segmented)
                    .listRowSeparator(.hidden)
                }
                
                Section("Date") {
                    Picker("Workout Date", selection: $vm.workoutFilter) {
                        ForEach(WorkoutDate.allCases, id: \.self) { type in
                            Text(type.rawValue)
                                .tag(type as WorkoutDate?)
                        }
                        Text("All")
                            .tag(nil as WorkoutDate?)
                    }
                    .pickerStyle(.segmented)
                    .listRowSeparator(.hidden)
                }
            }
            .navigationTitle("Workout Filter")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    if vm.loadingWorkouts {
                        ProgressView()
                    } else {
                        Text("\(vm.filteredWorkouts.count) / \(vm.workouts.count)")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        dismiss()
                    } label: {
                        DismissCross()
                    }
                    .buttonStyle(.plain)
                }
                ToolbarItem(placement: .principal) {
                    DraggableBar("Workout Filter")
                }
            }
        }
        .if { view in
            if #available(iOS 16, *) {
                view.presentationDetents([.medium])
            } else {
                view
            }
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
            .sheet(isPresented: .constant(true)) {
                FilterView()
                    .environmentObject(ViewModel())
            }
    }
}
