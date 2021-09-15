//
//  ConfigureUI.swift
//  14.7_HomeWork
//
//  Created by Саша on 10.09.2021.
//

import Foundation

class ConfigureUI {    
    
//MARK: - преобразование времени из UTC в привычный формат -
    
    func convertOfTime(_ dateUnix: Double) -> String {
        let date = Date(timeIntervalSince1970: dateUnix)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
//MARK: - шкала силы ветра в зависимости от скорости -
    
    func forceWindFunc (_ speed: Double) -> String {
        var returnValue = ""
        switch speed {
        case 0 ..< 0.2:
            returnValue = "Штиль"
        case 0.2 ..< 1.5:
            returnValue = "тихий"
        case 1.5 ..< 3.3:
            returnValue = "лёгкий"
        case 3.3 ..< 5.5:
            returnValue = "слабый"
        case 5.5 ..< 8:
            returnValue = "умеренный"
        case 8 ..< 10.8:
            returnValue = "свежий"
        case 10.8 ..< 13.9:
            returnValue = "сильный"
        case 13.9 ..< 17.1:
            returnValue = "крепкий"
        case 17.1 ..< 20.8:
            returnValue = "очень крепкий"
        case 20.8 ..< 24.5:
            returnValue = "ШТОРМ"
        case 24.5 ..< 28.5:
            returnValue = "СИЛЬНЫЙ ШТОРМ"
        case 28.5 ..< 32.6:
            returnValue = "ЖЁСТКИЙ ШТОРМ"
        case 32.6... :
            returnValue = "УРАГАН"
        default:
            break
        }
        return returnValue
    }
    
//MARK: - направление ветра -
    
    func degWindFunc (_ deg: Double) -> String {
        var returnValue = ""
        switch deg {
        case 348.75 ..< 360, 0 ..< 11.25:
            returnValue = "Северный"
        case 11.25 ..< 33.75:
            returnValue = "СевероСевероВосточный"
        case 33.75 ..< 56.25:
            returnValue = "СевероВосточный"
        case 56.25 ..< 78.75:
            returnValue = "ВосточноСевероВосточный"
        case 78.75 ..< 101.25:
            returnValue = "Восточный"
        case 101.25 ..< 123.75:
            returnValue = "ВосточноЮгоВосточный"
        case 123.75 ..< 146.25:
            returnValue = "ЮгоВосточный"
        case 146.25 ..< 168.75:
            returnValue = "ЮгоЮгоВосточный"
        case 168.75 ..< 191.25:
            returnValue = "Южный"
        case 191.25 ..< 213.75:
            returnValue = "ЮгоЮгоЗападный"
        case 213.75 ..< 236.25:
            returnValue = "ЮгоЗападный"
        case 236.25 ..< 258.75:
            returnValue = "ЗападноЮгоЗападный"
        case 258.75 ..< 281.25:
            returnValue = "Западный"
        case 281.25 ..< 303.75:
            returnValue = "ЗападноСевероЗападный"
        case 303.75 ..< 326.25:
            returnValue = "СевероЗападный"
        case 326.25 ..< 348.75:
            returnValue = "СевероСевероЗападный"
        default:
            break
        }
        return returnValue
    }
    
//MARK: - преобразование значения атмосферного давления из гПа в мм рт. ст. -
    
    func convertOfPressure (_ pressure: Int) -> String {
        let normalPressure = Double(pressure) * 0.750064
        var returnValue = "мм рт. ст."
        returnValue = String(normalPressure)
        if pressure == 0, returnValue.count < 6 {
            returnValue = "777.77"
        } else {
            while returnValue.count != 6 {
                returnValue.removeLast()
            }
        }
        return returnValue + " мм рт. ст."
    }
    
//MARK: - округление значения температуры -
    
    func roundingOfValue (_ value: Double) -> String {
        var returnValue = "?"
        var numberInt = Int(value)
        if value > Double(numberInt) + 0.5 {
            numberInt += 1
            returnValue = String("\(numberInt)")
        } else {
            returnValue = String("\(numberInt)")
        }
        return returnValue
    }
}
