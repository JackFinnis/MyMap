//
//  String.swift
//  News
//
//  Created by Jack Finnis on 13/01/2023.
//

import Foundation

extension String {
    var replaceSpaces: String {
        replacingOccurrences(of: " ", with: "%20")
    }
}
