//
//  WeatherEntity.swift
//  14.7_HomeWork
//
//  Created by Саша on 10.09.2021.
//

import Foundation
import CoreData

class WeatherEntity: NSManagedObject {
    
// Чтобы вот так просто получить доступ к контейнеру, пришлось в AppDelegate дописать статическое свойство.
    let container = AppDelegate.container    
    
//MARK: - метод, загружающий данные из памяти -
// В этом методе данные загружаются из памяти или возвращаются значения по умолчанию.
    func loadWeather (_ completionHandler: @escaping (ModelWeather?) -> Void) {
        print("-> Вызвана функция загрузки данных из памяти")
        let context = container.viewContext
        let request: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
        if let weatherEntity = try? context.fetch(request) {
            print("->> Количество элементов базе данных \(weatherEntity.count) <<-")
            let dt = weatherEntity.first?.dtWeather ?? 0
            let name = weatherEntity.first?.name ?? "?"
            let sunriseSys = weatherEntity.first?.sunrise ?? 0
            let sunsetSys = weatherEntity.first?.sunset ?? 0
            let allClouds = weatherEntity.first?.allClouds ?? 0
            let feelsLikeMain = weatherEntity.first?.feelsLike ?? 0
            let grndLevelMain = weatherEntity.first?.grndLevel ?? 0
            let humidityMain = weatherEntity.first?.humidity ?? 0
            let pressureMain = weatherEntity.first?.pressure ?? 0
            let seaLevelMain = weatherEntity.first?.seaLevel ?? 0
            let tempMain = weatherEntity.first?.temp ?? 0
            let tempMaxMain = weatherEntity.first?.tempMax ?? 0
            let tempMinMain = weatherEntity.first?.tempMin ?? 0
            let degWind = weatherEntity.first?.degWind ?? 0
            let gustWind = weatherEntity.first?.gustWind ?? 0
            let speedWind = weatherEntity.first?.speedWind ?? 0
            let descriptionWeather = weatherEntity.first?.descriptionWeather ?? "Описание погоды"
            let iconWeather = weatherEntity.first?.iconWeather ?? "?"
            let weather = Weather(description: descriptionWeather, icon: iconWeather)
            let wind = Wind(deg: degWind, gust: gustWind, speed: speedWind)
            let main = Main(feels_like: feelsLikeMain, grnd_level: Int(grndLevelMain), humidity: Int(humidityMain), pressure: Int(pressureMain), sea_level: Int(seaLevelMain), temp: tempMain, temp_max: tempMaxMain, temp_min: tempMinMain)
            let clouds = Clouds(all: Int(allClouds))
            let sys = Sys(sunrise: sunriseSys, sunset: sunsetSys)
            let modelWeather = ModelWeather(dt: dt, name: name, sys: sys, clouds: clouds, main: main, wind: wind, weather: [weather])
            completionHandler(modelWeather)
        }
    }
    
//MARK: - метод, обновляющий данные в памяти -

// Здесь данные пересохраняются.
    func updateWeather (_ weather: ModelWeather) {
        let context = container.viewContext
        let request: NSFetchRequest<WeatherEntity> = WeatherEntity.fetchRequest()
// Вернее сначала делается проверка на наличие данных в памяти.
        if let weatherEntity = try? context.fetch(request), weatherEntity.count != 0 {
// Если они там есть, то, понятно, что они уже устарели и их необходимо удалить.
            print("->> Данные удаляются из базы данных <<-")
            for weather in weatherEntity {
                context.delete(weather)
            }
        }
        try? context.save()
// А дальше сохранение актуалных данных.
        context.perform {
            print("->> Данные сохраняются в базу данных <<-")
            let weatherEntity = WeatherEntity(context: context)
            weatherEntity.name = weather.name
            weatherEntity.dtWeather = weather.dt
            
            weatherEntity.allClouds = Int64(weather.clouds.all)
            
            weatherEntity.descriptionWeather = weather.weather[0].description
            weatherEntity.iconWeather = weather.weather[0].icon
            
            weatherEntity.degWind = weather.wind.deg
            weatherEntity.gustWind = weather.wind.gust
            weatherEntity.speedWind = weather.wind.speed
            
            weatherEntity.sunrise = weather.sys.sunrise
            weatherEntity.sunset = weather.sys.sunset
            
            weatherEntity.temp = weather.main.temp
            weatherEntity.tempMax = weather.main.temp_max
            weatherEntity.tempMin = weather.main.temp_min
            weatherEntity.humidity = Int64(weather.main.humidity)
            weatherEntity.pressure = Int64(weather.main.pressure)
            weatherEntity.seaLevel = Int64(weather.main.sea_level)
            weatherEntity.feelsLike = weather.main.feels_like
            weatherEntity.grndLevel = Int64(weather.main.grnd_level)
        }
        try? context.save()
    }
}
