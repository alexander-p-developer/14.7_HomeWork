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
    
    private let currentDateTime = Int(Date().timeIntervalSince1970)
    
    var timeDateSince1970: Int? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: timeDateSince1970Key)
        }
        get {
            return UserDefaults.standard.integer(forKey: timeDateSince1970Key)
        }
    }
    
    func saveTimeIntervalSince1970 (_ currentTime: Int) {
        print("-> Текущее время запроса на сервер сохраняется.")
        UserDefaultsTime.shared.timeDateSince1970 = currentDateTime
    }
    
    func checkTimeIntervalSince1970OfLoad (_ currentTime: Int) -> Bool {
        print("-> Проводится проверка возможности отправки запроса на сервер.")
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
