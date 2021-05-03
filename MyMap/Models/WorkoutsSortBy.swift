//
//  WorkoutsSortBy.swift
//  MyMap
//
//  Created by Finnis on 26/04/2021.
//

import Foundation

enum SortStyle: String, CaseIterable {
    case ascending = "Ascending";
    case descending = "Descending";
    case none = "None"
}

class WorkoutsSortBy: ObservableObject {
    var date: SortStyle = .ascending
    var duration: SortStyle = .none
    var distance: SortStyle = .none
    var calories: SortStyle = .none
    var elevation: SortStyle = .none
}
