//
//  Emails.swift
//  MyMap
//
//  Created by Jack Finnis on 17/01/2023.
//

import UIKit

struct Emails {
    static func compose(subject: String) {
        if let url = URL(string: "mailto:" + EMAIL + "?subject=" + subject.replaceSpaces) {
            UIApplication.shared.open(url)
        }
    }
}

extension String {
    var replaceSpaces: String {
        replacingOccurrences(of: " ", with: "%20")
    }
}
