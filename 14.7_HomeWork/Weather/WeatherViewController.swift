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
        
    let radius: CGFloat = 20
    let viewColor: UIColor = .systemPink
    
//MARK: - Ссылки -
        
    let networkManager = NetworkManager()
    let configure = ConfigureUI()
    let weatherEntity = WeatherEntity()
    let refreshControl = UIRefreshControl()
    /*
     Создаю экземпляры необходимых классов для доступа к их свойствам и методам.
     */

//MARK: - viewDidLoad -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        scrollView.addSubview(refreshControl)
//        Здесь определяется что должен делать рефреш и где он будет находится.
        
        configureWeatherUI()
//        Настройка UI.
        weatherEntity.loadWeather { (dataWeather) in
            if dataWeather != nil, let weather = dataWeather {
                print("-> В памяти есть данные.")
                self.updateUI(weather)
                print("-> Данные загружены из памяти.")
            } else {
                print("-> Не удалось загрузить данные из памяти.")
            }
            let currentTime = Int(Date().timeIntervalSince1970)
            if UserDefaultsTime.shared.checkTimeIntervalSince1970OfLoad(currentTime) {
                print("-> С предыдущего запроса прошло уже более 10 минут, можно сделать очередной запрос.")
                print("-> currentTime в WeatherViewController = \(currentTime)")
                self.networkManager.getWeather { (weather) in
                    print("->> Данные загружены с сервера <<-")
                    UserDefaultsTime.shared.saveTimeIntervalSince1970(currentTime)
                    self.updateUI(weather)
                    self.weatherEntity.updateWeather(weather)
                }
            } else {
                print("-> С предыдущего запроса ещё не прошло 10 минут, в UI данные из памяти.")
            }
            
            
            
        }
        
        
////        Далее идёт обновление UI.
////        Сначала данные загружаются из базы данных, если, конечно, они там есть. При самом первом запуске приложение там, как раз, ничего и нет.
//        weatherEntity.loadWeather { (dataWeather) in
//            if dataWeather != nil, let weather = dataWeather {
//                self.updateUI(weather)
//                print("->> Данные загружены из базы данных <<-")
//            }
//
//            /*
//             Если уж в памяти ничего нет, тогда будем пытаться загрузить их с сервера. Но с одним условием: запрос можно отправить только через десять минут после последнего запроса. Дело в том, что данные на самом сервере обновляются с интервалом десять минут и чаще отправлять запррос не имеет смысла.
//             Для расчёта этого времени пришлось создать синглтон TimeManager.
//             */
//            if TimeManager.shared.checkTimeOfLoad(TimeManager.shared.timeFunc()) {
//// Запрос можно отправить - прошло более десяти минут.
//                self.networkManager.getWeather{ (weather) in
//                    TimeManager.shared.saveCurrentTime(TimeManager.shared.timeFunc())
//// При успешном ответе запоминаем это время. Следущий запрос возможен через десять минут.
//                    print("->> Данные загружены с сервера <<-")
//                    self.updateUI(weather)
////                    Обновляем UI.
//                    self.weatherEntity.updateWeather(weather)
////                    И сохраняем полученные значения в базу данных.
//                }
//            } else {
//                print("->> Данные не удалось загрузить с сервера <<-")
//                /*
//                 Если запрос не получилось отправить, то следующая попытка только через десять минут.
//                 В этот момент на экране может отображаться картинка по умолчанию, та, что собрана в сториборде.
//                 Чтобы всё же попробовать отправить запрос в любое время, нужно оттянуть вьюшку вниз, чтобы вызвался рефреш.
//                 */
//            }
//        }
    }
    
//MARK: - Метод, который обновляет данные о погоде при оттягивании вьюшки вниз -
     
//     Функция, запускаемая рефрешем.
    @objc func updateData () {
        var networkOff = true
//        Никакого ограничения по времени тут нет, так что отправляем запрос немедленно.
        networkManager.getWeather { (weather) in
            print("->> Данные подгружены с сервера <<-")
//            Обновляем UI.
            self.updateUI(weather)
//            Так же сохраним все данные.
            self.weatherEntity.updateWeather(weather)
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
//                И отключим рефреш - он уже не нужен.
                networkOff = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            if networkOff {
                let alert = UIAlertController(title: "Что-то пошло не так", message: "Проверьте соединение с сетью", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                self.refreshControl.endRefreshing()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    alert.dismiss(animated: true, completion: nil)
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
        
    private func configureWeatherUI() {
        let configViews = [weatherView, pressureView, windView, sysView]
        for view in configViews {
            view?.backgroundColor = viewColor
            view?.layer.cornerRadius = radius
        }        
    }
    
}

