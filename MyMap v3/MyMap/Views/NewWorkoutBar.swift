//
//  NewWorkoutBar.swift
//  MyMap
//
//  Created by Finnis on 04/03/2021.
//

import SwiftUI

struct NewWorkoutBar: View {
    @EnvironmentObject var vm: ViewModel
    
    @State var showEndWorkoutAlert = false
    
    var body: some View {
        Row {
            Text(vm.startDate.formatted())
        } trailing: {
            Text(vm.metres.formatted())
        }
        .padding(.horizontal)
        .font(.headline)
        .materialBackground()
    }
}
