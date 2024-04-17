//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Sanat S Salian on 17/04/24.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    var weatherManger = WeatherManager()
    var locationManger = CLLocationManager()
    
    @IBOutlet weak var conditionalImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureUnitLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var lat: Float = 0.0
    var lon: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManger.delegate = self
        weatherManger.delegate = self
        
        locationManger.requestWhenInUseAuthorization()
        locationManger.requestLocation()
    }
}


extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeatherManager(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.sync {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionalImageView.image = UIImage(systemName: weather.weatherCondition)
            cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}


extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManger.stopUpdatingLocation()
            lat = Float(location.coordinate.latitude)
            lon = Float(location.coordinate.longitude)
            weatherManger.fetchCurrentWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
        print("Error is: \(error)")
    }
}
