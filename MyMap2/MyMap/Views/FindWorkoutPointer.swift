//
//  FindWorkoutPointer.swift
//  MyMap
//
//  Created by Finnis on 13/06/2021.
//

import SwiftUI

struct FindWorkoutPointer: View {
    @EnvironmentObject var mapManager: MapManager
    
    var body: some View {
        if mapManager.searchState == .finding {
            Image(systemName: "circle")
                .font(.largeTitle)
                .foregroundColor(.accentColor)
        }
    }
}
