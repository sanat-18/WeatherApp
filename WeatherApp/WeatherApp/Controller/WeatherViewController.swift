//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Sanat S Salian on 17/04/24.
//

import UIKit
import CoreLocation

class WeatherViewController: BaseViewController {
    
    var locationManger = CLLocationManager()
    
    @IBOutlet weak var conditionalImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureUnitLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureTitleLabel: UILabel!
    @IBOutlet weak var feelsLikeTitleLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var feelsLikeUnitlabel: UILabel!
    @IBOutlet weak var searchForYourCityButton: UIButton!
    
    var lat: Float = 0.0
    var lon: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManger.delegate = self
        WeatherManager.sharedManager.delegate = self
        title = String(localized: "WEATHER")
        self.navigationController?.navigationBar.prefersLargeTitles = true
        locationManger.requestWhenInUseAuthorization()
        locationManger.requestLocation()
    }
    
    
    private func setUpLabelTitles() {
        temperatureTitleLabel.text = String(localized: "TEMPERATURE")
        feelsLikeTitleLabel.text = String(localized: "FEELS_LIKE")
        searchForYourCityButton.setTitle(String(localized: "SEARCH_FOR_YOUR_CITY"), for: .normal)
    }
    
    @IBAction func searchCityButtonTapped(_ sender: UIButton) {
        presentSearchViewController()
    }
}


extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeatherManager(_ weather: WeatherModel) {
        
        DispatchQueue.main.sync {
            stopActivityIndicator()
            temperatureLabel.text = weather.temperatureString
            conditionalImageView.image = UIImage(systemName: weather.weatherCondition)
            feelsLikeLabel.text = weather.feelsLikeTemperatureString
            cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        stopActivityIndicator()
        print(error)
    }
    
    private func presentSearchViewController() {
        if let searchVC = UIViewController.searchViewController() as? SearchViewController {
            searchVC.delegate = self
            searchVC.modalPresentationStyle = .pageSheet
            present(searchVC, animated: true, completion: nil)
        }
    }
    
    
}


extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManger.stopUpdatingLocation()
            lat = Float(location.coordinate.latitude)
            lon = Float(location.coordinate.longitude)
            startActivityIndicator()
            WeatherManager.sharedManager.fetchCurrentWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
        print(String(localized: "ERROR_IS") + " \(error)")
    }
}


extension WeatherViewController: SearchViewControllerDelegate {
    func fetchWeatherForCity(_ name: String) {
        startActivityIndicator()
        WeatherManager.sharedManager.fetchCityWeather(name)
    }
    
    
}

