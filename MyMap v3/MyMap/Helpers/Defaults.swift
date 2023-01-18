//
//  Defaults.swift
//  MyMap
//
//  Created by Jack Finnis on 17/01/2023.
//

import Foundation

@propertyWrapper
struct Defaults<ValueType> {
    let defaults = UserDefaults.standard
    
    let key: String
    let defaultValue: ValueType
    
    func reset() {
        defaults.set(defaultValue, forKey: key)
    }

    var wrappedValue: ValueType {
        get {
            defaults.object(forKey: key) as? ValueType ?? defaultValue
        }
        set {
            defaults.set(newValue, forKey: key)
        }
    }
}
