//
//  WorkoutsSortBy.swift
//  MyMap
//
//  Created by Finnis on 06/06/2021.
//

import Foundation

enum WorkoutsSortBy: String, CaseIterable {
    case startDate = "Start Date";
    case endDate = "End Date";
    
    case shortestDistance = "Shortest Distance";
    case longestDistance = "Longest Distance";
    
    case shortestDuration = "Shortest Duration";
    case longestDuration = "Longest Duration";
}
