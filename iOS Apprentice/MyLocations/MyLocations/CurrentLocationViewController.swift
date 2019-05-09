//
//  CurrentLocationViewController.swift
//  MyLocations
//
//  Created by Maksim Nosov on 05/05/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import AudioToolbox

class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate, CAAnimationDelegate {
    
    // Необходимо добавить в в Info.plist требования для установки приложения из AppStore
    // В Required device capabilities добавить значения:
    // location-services
    // gps
    
    let locationManager = CLLocationManager() // объект, которые дает GPS координаты
    var location: CLLocation? // Данные с координатами
    var updatingLocation = false // Обновлять локацию?
    var lastLocationError: Error? // Последняя полученная ошибка в процессе получения локации
    let geocoder = CLGeocoder() // Интерфейс для конвертирования географических координат в названия расположения
    var placemark: CLPlacemark? // Объект, содержащий результаты получения адреса из координат
    var performingReverseGeocoding = false // Когда операция геокодирования в процессе
    var lastGeocodingError: Error? // Последняя полученная ошибка в процессе геокодирования
    var timer: Timer? // Таймер для отсчета времени после старта определения местоположения в startLocationManager()
    var soundID: SystemSoundID = 0 // Системный звук для нотификации. 0 - обозначает, что еще не загружен системный звук
    
    var logoVisible = false
    
    lazy var logoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "Logo"), for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(getLocation), for: .touchUpInside)
        button.center.x = self.view.bounds.midX
        button.center.y = 220
        return button
    }()
    
    // Core Data
    var managedObjectContext: NSManagedObjectContext!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    @IBOutlet weak var latitudeTextLabel: UILabel!
    @IBOutlet weak var longitudeTextLabel: UILabel!
    @IBOutlet weak var containerView: UIView! // View без insets в котором находятся остальные IBOutlets
    
    // MARK: - Actions
    @IBAction func getLocation() {
        
        let authStatus = CLLocationManager.authorizationStatus() // Статус авторизации для получения координат на устройстве
        // если еще не запрашивали разрешение у пользователя, то запросим.
        // Также надо добавить специальный ключ в Info.plist для ключа
        // Privacy - Location When In Use Usage Description значение This app lets you keep track of interesting places. It needs access to the GPS coordinates for your location
        
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        
        if logoVisible {
            hideLogoView()
        }
        
        // Отработка нажатия кнопки в процессе получения координат
        if updatingLocation {
            stopLocationManager()
            print("User has stopped getting location.")
        } else {
            placemark = nil
            lastGeocodingError = nil
            startLocationManager()
        }
        
        updateLabels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLabels()
        loadSoundEffect("Sound.caf")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true // Скрыть Navigation Bar во всем стеке Navigation Controller
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false // Перед уходом с View Controller отображать Navigation Bar во всем стеке Navigation Controller
    }
    
    // MARK:- Sound effects
    func loadSoundEffect(_ name: String) {
        if let path = Bundle.main.path(forResource: name, ofType: nil) {
            let fileURL = URL(fileURLWithPath: path, isDirectory: false)
            let error = AudioServicesCreateSystemSoundID(fileURL as CFURL, &soundID)
            if error != kAudioServicesNoError {
                print("Error code \(error) loading sound: \(path)")
            }
        }
    }
    
    func unloadSoundEffect() {
        AudioServicesDisposeSystemSoundID(soundID)
        soundID = 0
    }
    
    func playSoundEffect() {
        AudioServicesPlaySystemSound(soundID)
    }
    
    // MARK:- Navigation
    // Подготовка к вызову Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TagLocation" {
            let controller = segue.destination as! LocationDetailsViewController
            controller.coordinate = location!.coordinate
            controller.placemark = placemark
            
            controller.managedObjectContext = managedObjectContext // dependency injection
        }
    }
    
    // MARK:- Helper Methods
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled",
                                      message: "Please enable location services for this app in Settings.",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // Отобразить лого на главном экране
    func showLogoView() {
        if !logoVisible {
            logoVisible = true
            containerView.isHidden = true
            view.addSubview(logoButton)
        }
    }
    
    // Скрыть лого на главном экране
    func hideLogoView() {
        if !logoVisible { return }
        
        logoVisible = false
        containerView.isHidden = false
        containerView.center.x = view.bounds.size.width * 2
        containerView.center.y = 40 +
            containerView.bounds.size.height / 2
        
        let centerX = view.bounds.midX
        
        let panelMover = CABasicAnimation(keyPath: "position")
        panelMover.isRemovedOnCompletion = false
        panelMover.fillMode = CAMediaTimingFillMode.forwards
        panelMover.duration = 0.6
        panelMover.fromValue = NSValue(cgPoint: containerView.center)
        panelMover.toValue = NSValue(cgPoint:
            CGPoint(x: centerX, y: containerView.center.y))
        panelMover.timingFunction = CAMediaTimingFunction(
            name: CAMediaTimingFunctionName.easeOut)
        panelMover.delegate = self
        containerView.layer.add(panelMover, forKey: "panelMover")
        
        let logoMover = CABasicAnimation(keyPath: "position")
        logoMover.isRemovedOnCompletion = false
        logoMover.fillMode = CAMediaTimingFillMode.forwards
        logoMover.duration = 0.5
        logoMover.fromValue = NSValue(cgPoint: logoButton.center)
        logoMover.toValue = NSValue(cgPoint:
            CGPoint(x: -centerX, y: logoButton.center.y))
        logoMover.timingFunction = CAMediaTimingFunction(
            name: CAMediaTimingFunctionName.easeIn)
        logoButton.layer.add(logoMover, forKey: "logoMover")
        
        let logoRotator = CABasicAnimation(keyPath:
            "transform.rotation.z")
        logoRotator.isRemovedOnCompletion = false
        logoRotator.fillMode = CAMediaTimingFillMode.forwards
        logoRotator.duration = 0.5
        
        logoRotator.fromValue = 0.0
        logoRotator.toValue = -2 * Double.pi
        logoRotator.timingFunction = CAMediaTimingFunction(
            name: CAMediaTimingFunctionName.easeIn)
        logoButton.layer.add(logoRotator, forKey: "logoRotator")
    }
    
    // MARK:- Animation Delegate Methods
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        containerView.layer.removeAllAnimations()
        containerView.center.x = view.bounds.size.width / 2
        containerView.center.y = 40 + containerView.bounds.size.height / 2
        logoButton.layer.removeAllAnimations()
        logoButton.removeFromSuperview()
    }
    
    func updateLabels() {
        if let location = location {
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            
            tagButton.isHidden = false
            messageLabel.text = ""
            // Отображение адреса
            if let placemark = placemark {
                addressLabel.text = string(from: placemark)
            } else if performingReverseGeocoding {
                addressLabel.text = "Searching for Address..."
            } else if lastGeocodingError != nil {
                addressLabel.text = "Error Finding Address"
            } else {
                addressLabel.text = "No Address Found"
            }
            latitudeTextLabel.isHidden = false
            longitudeTextLabel.isHidden = false
            
        } else {
            
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            addressLabel.text = ""
            tagButton.isHidden = true
            
            latitudeTextLabel.isHidden = true
            longitudeTextLabel.isHidden = true
            
            let statusMessage: String
            if let error = lastLocationError as NSError? {
                // Если нет доступа на устройстве для получения координат
                if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue {
                    statusMessage = "Location Services Disabled"
                } else {
                    // Если что-то другое, то выводим общую формулировку
                    statusMessage = "Error Getting Location"
                }
                // Если отключена система навигации на устройстве
            } else if !CLLocationManager.locationServicesEnabled() {
                statusMessage = "Location Services Disabled"
                // Если все хорошо, то вывести сообщение "Searching..."
            } else if updatingLocation {
                statusMessage = "Searching..."
            } else {
                // Иначе, отобразить приглашение к нажатию кнопки для определения текущих координат
                statusMessage = ""
                showLogoView()
            }
            
            messageLabel.text = statusMessage
        }
        configureGetButton()
    }
    
    func configureGetButton() {
        let spinnerTag = 1000
        
        if updatingLocation {
            getButton.setTitle("Stop", for: .normal)
            
            // Отображение Activity Indicator
            if view.viewWithTag(spinnerTag) == nil {
                let spinner = UIActivityIndicatorView(style: .white)
                spinner.center = messageLabel.center
                spinner.center.y += spinner.bounds.size.height / 2 + 25
                spinner.startAnimating()
                spinner.tag = spinnerTag
                containerView.addSubview(spinner)
            }
        } else {
            getButton.setTitle("Get My Location", for: .normal)
            
            if let spinner = view.viewWithTag(spinnerTag) {
                spinner.removeFromSuperview()
            }
        }
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() { // Если сервис позиционирования включен на устройстве
            locationManager.delegate = self // назначаем делегатом текущий View Controller
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters // Точность расположения в 10 метрах
            locationManager.startUpdatingLocation() // Запускаем locationManager. С этого момента объект будет отправлять обновления расположения своему делегату, т.е. CurrentLocationViewController
            updatingLocation = true
            
            // Устанавливаем таймер на 5 секунд, по истечении которых запустить метод didTimeOut
            timer = Timer.scheduledTimer(timeInterval: 5,
                                         target: self,
                                         selector: #selector(didTimeOut),
                                         userInfo: nil,
                                         repeats: false)
        }
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
            
            if let timer = timer {
                timer.invalidate() // Останавливаем таймер и удаляем его из Run loop
            }
        }
    }

    @objc func didTimeOut() {
        print("*** Time out")
        if location == nil {
            stopLocationManager()
            lastLocationError = NSError(
                domain: "MyLocationsErrorDomain",
                code: 1, userInfo: nil)
            updateLabels()
        } else {
            print(location!)
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    // Если ошибка получения координат
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error.localizedDescription)")
        
        if (error as NSError).code == CLError.locationUnknown.rawValue { return }
        
        lastLocationError = error
        stopLocationManager()
        updateLabels()
    }
    
    // Получены новые координаты
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        location = newLocation
        print("didUpdateLocations \(newLocation)")
        
        // Если время получение расположения определено слишком давно (- в этом случае - кешированный результат) игнорируем его.
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        
        // если точность для нового расположение меньше 0, то измерение неверное - игнорируем его
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        
        var distance = CLLocationDistance(Double.greatestFiniteMagnitude)
        if let location = location {
            distance = newLocation.distance(from: location)
        }
        
        // если nil значение (если это первый запуск и мы еще не присваивали рабочей переменной location позицию) или точность прошлой локации больше(менее точнее в метрах/милях), то используем новую локацию
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            lastLocationError = nil // После получения координаты, любая предыдущая ошибка не имеет значения.
            location = newLocation
        }
        
        // Если точность позиционирования меньше или равно заданной нами точности для CLLocationManager - мы получили желаемый результат
        if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
            print("*** We're done!")
            stopLocationManager()
            
            if distance > 0 {
                performingReverseGeocoding = false
            }
        }
        updateLabels()
        
        if !performingReverseGeocoding {
            print("*** Going to geocode")
            performingReverseGeocoding = true // Геокодинг в процессе
            
            geocoder.reverseGeocodeLocation(newLocation, completionHandler: { placemarks, error in
                self.lastGeocodingError = error
                
                // обработка ошибки и получение последней записи из массива с полученными локациями при геокодировании.
                if error == nil, let p = placemarks, !p.isEmpty {
                    if self.placemark == nil {
                        print("FIRST TIME!")
                        self.playSoundEffect()
                    }
                    self.placemark = p.last!
                } else {
                    self.placemark = nil
                }
                
                self.performingReverseGeocoding = false // Геокодинг не выполняется
                self.updateLabels()
            })
        } else {
            if distance < 1 {
                let timeInterval = newLocation.timestamp.timeIntervalSince(location!.timestamp)
                if timeInterval > 10 {
                    print("*** Force done!")
                    stopLocationManager()
                    updateLabels()
                }
            }
        }
    } // Конец didUpdateLocations
    
}

