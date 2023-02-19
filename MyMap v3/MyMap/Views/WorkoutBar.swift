//
//  WorkoutInfoBar.swift
//  MyMap
//
//  Created by Finnis on 13/06/2021.
//

import SwiftUI
import MapKit

struct WorkoutBar: View {
    @EnvironmentObject var vm: ViewModel
    @State var showWorkoutView = false
    @State var offset = Double.zero
    
    let workout: Workout
    let new: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(workout.type.rawValue)
                    .font(.headline)
                Spacer()
                if new {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.red)
                        .font(.footnote)
                        .opacity(vm.pulse ? 1 : 0)
                } else {
                    Text(workout.date.formattedApple())
                }
            }
            .animation(.default, value: vm.pulse)
            
            GeometryReader { geo in
                let width = geo.size.width
                WorkoutStat(name: "Distance", value: Measurement(value: workout.distance, unit: UnitLength.meters).formatted(), width: width)
                WorkoutStat(name: "Duration", value: DateComponentsFormatter().string(from: workout.duration) ?? "", width: width)
                WorkoutStat(name: "Speed", value: Measurement(value: workout.distance / workout.duration, unit: UnitSpeed.metersPerSecond).formatted(), width: width)
                WorkoutStat(name: "Elevation", value: Measurement(value: workout.elevation, unit: UnitLength.meters).formatted(), width: width)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .materialBackground()
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .onTapGesture {
            vm.zoomTo(workout)
        }
        .if(!new) { $0
            .offset(x: 0, y: offset)
            .opacity((100 - offset)/100)
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { value in
                    if value.translation.height > 0 {
                        offset = value.translation.height
                    }
                }
                .onEnded { value in
                    if value.predictedEndTranslation.height > 50 {
                        vm.selectedWorkout = nil
                    } else {
                        withAnimation(.spring()) {
                            offset = 0
                        }
                    }
                }
            )
        }
    }
}

struct WorkoutBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Map(mapRect: .constant(MKMapRect()))
            WorkoutBar(workout: .example, new: true)
                .environmentObject(ViewModel())
        }
    }
}

struct WorkoutStat: View {
    let name: String
    let value: String
    let width: Double
    
    var body: some View {
        VStack(spacing: 3) {
            Text(name)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
        }
        .frame(width: width)
    }
}
