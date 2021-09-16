//
//  ViewController.swift
//  14.7_HomeWork
//
//  Created by Саша on 09.09.2021.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView! // пришлось сделать этот аутлет только для рефреша
    
//MARK: - UI -
    /*
     UI этой части приложения визуально разбит на несколько разделов.
     В первом разделе показано название города, для которого отображается текущая погода, крраткое описание погоды, иконка текущей погоды (можно было придумать свою, но я воспользовался той, что в API), текущая температура и температурный интервал (максимальная и минимальная температура, а также как она ощущается. Значения температуры пришлось округлять в отдельной функции файла ConfigureUI.
     Во втором разделе я поместил информацию о влажности воздуха, силе, направлении и скорости ветра. Силу ветра указывал в зависимости от скорости. Все необходимые преобразования я делал в файле ConfigureUI.
     В третьем разделе информация об атмосферном давлении и облачности. Для значением атмосферного давления тоже пришлось придумывать отдельную функцию чтобы преобразовать гектопаскали в мм ртутного столба, а потом ещё убирать лишние символы после запятой. Всё это также производилось в файле ConfigureUI.
     В четвёртом разделе время восхода и захода солнца. Опять же, с сервера время приходит в формате unix, поэтому так же выручила одна из функций в классе ConfigureUI.
     */
    
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var intervalOfTempAndfeelsLikeLabel: UILabel!
    
    @IBOutlet weak var pressureView: UIView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var seaLevelLabel: UILabel!
    @IBOutlet weak var grndLevelLabel: UILabel!
    @IBOutlet weak var cloudLabel: UILabel!
    
    @IBOutlet weak var windView: UIView!
    @IBOutlet weak var degWindLabel: UILabel!
    @IBOutlet weak var speedWindLabel: UILabel!
    @IBOutlet weak var forceWindLabel: UILabel!
    @IBOutlet weak var gustWindLabel: UILabel!
    
    @IBOutlet weak var sysView: UIView!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
//MARK: - Constants -
//   Это для UI
    let radius: CGFloat = 20
    let viewColor: UIColor = .systemPink
    
//MARK: - Ссылки -
        
    let networkManager = NetworkManager()
    let configure = ConfigureUI()
    let weatherEntity = WeatherEntity()
    let refreshControl = UIRefreshControl()
    
//  Создаю экземпляры необходимых классов для доступа к их свойствам и методам.     

//MARK: - viewDidLoad -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        scrollView.addSubview(refreshControl)
//  Здесь определяется что должен делать рефреш и где он будет находится.
        
        configureWeatherUI(alpha: 1) // Настройка UI
//  Сначала данные загружаются из базы данных, если, конечно, они там есть. При самом первом запуске приложение там, как раз, ничего и нет.
        weatherEntity.loadWeather { (dataWeather) in
            if dataWeather != nil, let weather = dataWeather {
                self.updateUI(weather) // если всё в порядке, обновляем UI
            }
            let currentTime = Int(Date().timeIntervalSince1970) // сохраняем текущее время в currentTime
//  Передаём значение переменной currentTime функции проверки времени предыдущего запроса на сервер
            if UserDefaultsTime.shared.isCanSendRequest(currentTime) {
//  Если с предыдущего запроса на сервер прошло уже более десяти минут, отправляем новый запрос на сервер
                self.networkManager.getWeather { (weather) in
//  При успешном выполнении запроса, сохраняем текущее время, передав его специальной функции
                    UserDefaultsTime.shared.saveCurrentTime(currentTime)
                    self.updateUI(weather) // Обновим UI, используя загруженные с сервера данные
                    self.weatherEntity.updateWeather(weather) // и перезапишем их в базу данных
                }
            }
/*
Если запрос не получилось отправить, то следующая попытка только через десять минут.
В этот момент на экране может отображаться картинка по умолчанию, та, что собрана в сториборде.
Чтобы всё же попробовать отправить запрос в любое время, нужно оттянуть вьюшку вниз, чтобы вызвался рефреш.
*/
        }
    }
    
//MARK: - Метод, который обновляет данные о погоде при оттягивании вьюшки вниз -
     
//  Функция, запускаемая рефрешем.
    @objc func updateData () {
        var networkOff = true // вспомогательная переменная для алёрта
//  Никакого ограничения по времени тут нет, так что отправляем запрос немедленно.
        networkManager.getWeather { (weather) in
            self.updateUI(weather) // Обновляем UI
            self.weatherEntity.updateWeather(weather) // и сохраним данные с севера в базу данных
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing() // Данные загружены и рефреш больше не нужен
                networkOff = false // Алёрт тоже
            }
        }
// На всякий случай ждём три секунды
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            if networkOff {
// Если загрузка не получилась, то сделаем UI полупрозрачным и покажем пользователю алёрт
                self.configureWeatherUI(alpha: 0.5)
                let alert = UIAlertController(title: "Что-то пошло не так", message: "Проверьте соединение с сетью", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                self.refreshControl.endRefreshing() // рефреш тоже уберём
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
// Через две секунды уберём алёрт и сделаем UI чётким непрозачным
                    alert.dismiss(animated: true, completion: nil)
                    self.configureWeatherUI(alpha: 1)
                })
            }
        })
    }
    
//MARK: - метод обновления пользовательского интерфейса -
        
    func updateUI(_ weather: ModelWeather) {
        DispatchQueue.main.async {
            self.nameLabel.text = weather.name
            self.descriptionLabel.text = weather.weather[0].description
            self.tempLabel.text = "\(self.configure.roundingOfValue(weather.main.temp))°"
            self.intervalOfTempAndfeelsLikeLabel.text = "Максимум  \(self.configure.roundingOfValue(weather.main.temp_max))°,  минимум  \(self.configure.roundingOfValue(weather.main.temp_min))°, ощущается как \(self.configure.roundingOfValue(weather.main.feels_like))°"
            self.iconImageView.image = self.networkManager.loadImage(weather)
                
            self.humidityLabel.text = String("\(weather.main.humidity) %")
            self.forceWindLabel.text = "Ветер \(self.configure.forceWindFunc(weather.wind.speed))"
            self.degWindLabel.text = self.configure.degWindFunc(weather.wind.deg)
            self.speedWindLabel.text = "скорость \(self.configure.roundingOfValue(weather.wind.speed)) м/с"
            self.gustWindLabel.text = "с порывами \(self.configure.roundingOfValue(weather.wind.gust)) м/с"
                
            self.pressureLabel.text = self.configure.convertOfPressure(weather.main.pressure)
            self.seaLevelLabel.text = "на уровне моря \(self.configure.convertOfPressure(weather.main.sea_level))"
            self.grndLevelLabel.text = "на уровне земли \(self.configure.convertOfPressure(weather.main.grnd_level))"
            self.cloudLabel.text = "\(weather.clouds.all) %"
                
            self.sunriseLabel.text = self.configure.convertOfTime(weather.sys.sunrise)
            self.sunsetLabel.text = self.configure.convertOfTime(weather.sys.sunset)
        }
    }
    
//MARK: - конфигурация вьюшек и меток -
        
    private func configureWeatherUI(alpha: CGFloat) {
        let configViews = [weatherView, pressureView, windView, sysView]
        for view in configViews {
            view?.backgroundColor = viewColor
            view?.layer.cornerRadius = radius
            view?.alpha = alpha
        }        
    }    
}

