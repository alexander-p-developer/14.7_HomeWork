//
//  ModelWeather.swift
//  14.7_HomeWork
//
//  Created by Саша on 10.09.2021.
//

import Foundation

struct Weather: Codable {
    var description: String // Погодные условия в группе.
    var icon: String // Идентификатор значка погоды
}

struct Wind: Codable {
    var deg: Double // Направление ветра, градусы (метеорологические)
    var gust: Double // Порыв ветра.
    var speed: Double // Скорость ветра.
}

struct Main: Codable {
    var feels_like: Double // Температура. Этот температурный параметр объясняет восприятие человеком погоды.
    var grnd_level: Int // Атмосферное давление на уровне земли, гПа
    var humidity: Int // Влажность, %
    var pressure: Int // Атмосферное давление (на уровне моря, если нет данных об уровне моря или grnd_level), hPa
    var sea_level: Int // Атмосферное давление на уровне моря, гПа
    var temp: Double // Температура.
    var temp_max: Double // Максимальная температура в данный момент. Это максимальная температура, наблюдаемая в настоящее время (в крупных мегаполисах и городских районах).
    var temp_min: Double // Минимальная температура в данный момент. Это минимальная температура, наблюдаемая в настоящее время (в крупных мегаполисах и городских районах).
}

struct Clouds: Codable { // Облачность
    var all: Int
}

struct Sys: Codable {
    var sunrise: Double // Точное время восхода солнца, unix, UTC
    var sunset: Double // Время захода солнца, unix, UTC
}

class ModelWeather: Codable {
    var dt: Double // Время расчёта данных, unix, UTC
    var name: String // Название города
    var sys: Sys
    var clouds: Clouds
    var main: Main
    var wind: Wind
    var weather: [Weather]
    init (dt: Double, name: String, sys: Sys, clouds: Clouds, main: Main, wind: Wind, weather: [Weather]) {
        self.dt = dt
        self.name = name
        self.sys = sys
        self.clouds = clouds
        self.main = main
        self.wind = wind
        self.weather = weather
    }
}
