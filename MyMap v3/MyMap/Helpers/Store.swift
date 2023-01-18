//
//  Store.swift
//  MyMap
//
//  Created by Jack Finnis on 17/01/2023.
//

import UIKit
import StoreKit

struct Store {
    static func requestRating() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    static func writeReview() {
        var components = URLComponents(url: APP_URL, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "action", value: "write-review")
        ]
        if let url = components?.url {
            UIApplication.shared.open(url)
        }
    }
}
