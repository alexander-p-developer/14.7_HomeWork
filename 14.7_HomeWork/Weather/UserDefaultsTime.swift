//
//  UserDefaultsTime.swift
//  14.7_HomeWork
//
//  Created by Саша on 10.09.2021.
//

import Foundation
// Этот класс для сохранения текущего времени и дня, необходим, чтобы рассчитать время следующего запроса на сервер.

class UserDefaultsTime {
    static let shared = UserDefaultsTime()
    
    private let timeDateSince1970Key = "UserDefaultsTime.timeDateSince1970Key"    
     
    var timeDateSince1970: Int? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: timeDateSince1970Key)
        }
        get {
            return UserDefaults.standard.integer(forKey: timeDateSince1970Key)
        }
    }
    
    func saveCurrentTime (_ currentTime: Int) {
        UserDefaultsTime.shared.timeDateSince1970 = currentTime
    }
    
    func isCanSendRequest (_ currentTime: Int) -> Bool {
        var isTenMinutesOff = false
        if let savedTime = UserDefaultsTime.shared.timeDateSince1970 {
            if savedTime != 0,
               currentTime <= savedTime + 600 {
                isTenMinutesOff = false
            } else {
                isTenMinutesOff = true
            }
        }
        return isTenMinutesOff
    }
}
