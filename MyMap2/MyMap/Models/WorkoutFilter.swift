//
//  WorkoutFilter.swift
//  MyMap
//
//  Created by Finnis, Jack (PGW) on 11/06/2021.
//

import Foundation

struct WorkoutFilter {
    var type: WorkoutFilterType
    var filter: Bool = false
    var maximum: Double = 0
    var minimum: Double = 0
    var summary: String {
        if !filter {
            return ""
        } else if minimum >= maximum {
            return "> \(Int(minimum)) \(type.rawValue)"
        } else {
            return "\(Int(minimum))-\(Int(maximum)) \(type.rawValue)"
        }
    }
}
