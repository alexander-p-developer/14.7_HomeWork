//
//  NetworkManager.swift
//  14.7_HomeWork
//
//  Created by Саша on 10.09.2021.
//

import Foundation
import UIKit

class NetworkManager {
    
//MARK: - константы URL -
    
//    Заготовки URL.
    let endPoint = "https://api.openweathermap.org/data/2.5/weather?"
    let apiId = "&appid=7dcadc7941f60647cf5ac78025bec967"
    let cityId = "id=524901"
    let cityName = "q=Moscow,RU"
    let units = "&units=metric"
    let lang = "&lang=ru"
    
//    Заготовка URL картинки.
    let iconURL = "https://openweathermap.org/img/wn/"
    let imageURL = "@2x.png"
    
//MARK: - запрос текущей погоды на сервер -
    
    func getWeather(_ complitionHendler: @escaping (ModelWeather) -> Void) {
        if let url = URL(string: endPoint + cityId + units + lang + apiId) {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print("error: \(String(describing: error?.localizedDescription))")
                } else if let responseAnswer = response as? HTTPURLResponse,
                          responseAnswer.statusCode == 200,
                          let responseData = data {
                                let decoder = JSONDecoder()
                                if let weatherApi = try? decoder.decode(ModelWeather.self, from: responseData) {
                                    complitionHendler(weatherApi)
                                }
                }
            }
            task.resume()
        }
    }
    
//MARK: - загрузка изображения значка погоды -
    
    func loadImage(_ json: ModelWeather) -> UIImage? {
        var returnValue: UIImage?
        let imageJson = json.weather[0].icon
        if  let url = URL(string: iconURL + imageJson + imageURL),
            let imageData = try? Data(contentsOf: url) {
                returnValue = UIImage(data: imageData)
        }
        return returnValue
    }
}
