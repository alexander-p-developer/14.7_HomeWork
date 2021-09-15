//
//  Persistance.swift
//  14.7_HomeWork
//
//  Created by Саша on 09.09.2021.
//

import Foundation

class Persistance {
    static let shared = Persistance()
    
    private let userNameKey = "Persistance.userNameKey"
    private let userSurnameKey = "Persistance.userSurNameKey"
    
    var userName: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: userNameKey)
        }
        get {
            return UserDefaults.standard.string(forKey: userNameKey)
        }
    }
    
    var userSurname: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: userSurnameKey)
        }
        get {
            return UserDefaults.standard.string(forKey: userSurnameKey)
        }
    }
    
}
