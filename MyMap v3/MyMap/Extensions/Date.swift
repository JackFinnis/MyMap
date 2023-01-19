//
//  Date.swift
//  Ecommunity
//
//  Created by Jack Finnis on 24/11/2021.
//

import Foundation

extension Date {
    func formattedApple() -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        let oneWeekAgo = calendar.startOfDay(for: Date.now.addingTimeInterval(-7*24*3600))
        let oneWeekAfter = calendar.startOfDay(for: Date.now.addingTimeInterval(7*24*3600))
        
        if calendar.isDateInToday(self) {
            return formatted(date: .omitted, time: .shortened)
        } else if calendar.isDateInYesterday(self) || calendar.isDateInTomorrow(self) {
            formatter.doesRelativeDateFormatting = true
            formatter.dateStyle = .full
        } else if self > oneWeekAgo && self < oneWeekAfter {
            formatter.dateFormat = "EEEE"
        } else if calendar.isDate(self, equalTo: .now, toGranularity: .year) {
            formatter.dateFormat = "d MMM"
        } else {
            formatter.dateFormat = "d MMM y"
        }
        return formatter.string(from: self)
    }
}
