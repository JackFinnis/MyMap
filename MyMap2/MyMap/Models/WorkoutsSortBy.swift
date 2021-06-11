//
//  WorkoutsSortBy.swift
//  MyMap
//
//  Created by Finnis on 06/06/2021.
//

import Foundation

enum WorkoutsSortBy: String, CaseIterable {
    case startDate = "Oldest"
    case endDate = "Newest"
    case shortestDistance = "Shortest Distance"
    case longestDistance = "Longest Distance"
    case shortestDuration = "Shortest Duration"
    case longestDuration = "Longest Duration"
//    case lowestCalories = "Lowest Calories"
//    case mostCalories = "Most Calories"
//    case leastElevation = "Least Elevation"
//    case greatestElevation = "Greatest Elevation"
}
