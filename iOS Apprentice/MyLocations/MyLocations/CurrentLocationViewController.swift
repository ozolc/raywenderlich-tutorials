//
//  CurrentLocationViewController.swift
//  MyLocations
//
//  Created by Maksim Nosov on 05/05/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager() // объект, которые дает GPS координаты
    var location: CLLocation? // Данные с координатами
    var updatingLocation = false // Обновлять локацию?
    var lastLocationError: Error? // Последняя полученная ошибка в процессе получения локации
    let geocoder = CLGeocoder() // Интерфейс для конвертирования географических координат в названия расположения
    var placemark: CLPlacemark? // Объект, содержащий результаты получения адреса из координатам
    var performingReverseGeocoding = false // Когда операция геокодирования в процессе
    var lastGeocodingError: Error? // Последняя полученная ошибка в процессе геокодирования
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    
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
        
        // Отработка нажатия кнопки в процессе получения координат
        if updatingLocation {
            stopLocationManager()
            print("User has stopped getting location.")
        } else {
            location = nil
            lastLocationError = nil
            startLocationManager()
        }
        
        updateLabels()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
     
        updateLabels()
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
    
    func updateLabels() {
        if let location = location {
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            
            tagButton.isHidden = false
            messageLabel.text = ""
        } else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            addressLabel.text = ""
            tagButton.isHidden = true
            
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
                statusMessage = "Tap 'Get My Location' to Start"
            }
            
            messageLabel.text = statusMessage
        }
        configureGetButton()
    }
    
    func configureGetButton() {
        if updatingLocation {
            getButton.setTitle("Stop", for: .normal)
        } else {
            getButton.setTitle("Get My Location", for: .normal)
        }
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() { // Если сервис позиционирования включен на устройстве
            locationManager.delegate = self // назначаем делегатом текущий View Controller
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters // Точность расположения в 10 метрах
            locationManager.startUpdatingLocation() // Запускаем locationManager. С этого момента объект будет отправлять обновления расположения своему делегату, т.е. CurrentLocationViewController
            updatingLocation = true
        }
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
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
        
        // если nil значение (если это первый запуск и мы еще не присваивали рабочей переменной location позицию) или точность прошлой локации больше(менее точнее в метрах/милях), то используем новую локацию
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            lastLocationError = nil // После получения координаты, любая предыдущая ошибка не имеет значения.
            location = newLocation
        }
        
        // Если точность позиционирования меньше или равно заданной нами точности для CLLocationManager - мы получили желаемый результат
        if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
            print("*** We're done!")
            stopLocationManager()
        }
        updateLabels()
        
        if !performingReverseGeocoding {
            print("*** Going to geocode")
            performingReverseGeocoding = true // Геокодинг в процессе
            
            geocoder.reverseGeocodeLocation(newLocation, completionHandler: { placemarks, error in
                self.lastGeocodingError = error
                
                // обработка ошибки и получение последней записи из массива с полученными локациями при геокодировании.
                if error == nil, let p = placemarks, !p.isEmpty {
                    self.placemark = p.last!
                } else {
                    self.placemark = nil
                }
                
                self.performingReverseGeocoding = false // Геокодинг не выполняется
                self.updateLabels()
            })
        }
    } // Конец didUpdateLocations

}

