//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Sanat S Salian on 17/04/24.
//

import UIKit
import CoreLocation

class WeatherViewController: BaseViewController {
    
    fileprivate let locationManger = CLLocationManager()
    fileprivate var currentLocation: CLLocation?
    private let weatherService: WeatherServiceDelegate
    var weatherModel: WeatherModel?
    
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
    
    init(weatherService: WeatherServiceDelegate = WeatherService()) {
        self.weatherService = weatherService
        super.init(nibName: nil, bundle: nil)
      }
    
    required init?(coder: NSCoder) {
        self.weatherService = WeatherService()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = String(localized: "WEATHER")
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpLocation()
    }
    
    private func setUpLocation() {
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()
        locationManger.requestLocation()
    }
    
    private func setUpLabelTitles() {
        temperatureTitleLabel.text = String(localized: "TEMPERATURE")
        feelsLikeTitleLabel.text = String(localized: "FEELS_LIKE")
        searchForYourCityButton.setTitle(String(localized: "SEARCH_FOR_YOUR_CITY"), for: .normal)
    }
    
    private func updateLLabels() {
        if let weatherModel = weatherModel {
            //Update labels
            
            feelsLikeLabel.text = weatherModel.feelsLikeTemperatureString
            conditionalImageView.image = UIImage(systemName: weatherModel.weatherCondition)
            cityLabel.text = weatherModel.cityName + ", " + weatherModel.country
            temperatureLabel.text = weatherModel.temperatureString
            
        }
        
    }
    
    private func presentSearchViewController() {
        if let searchVC = UIViewController.searchViewController() as? SearchViewController {
            searchVC.delegate = self
            searchVC.modalPresentationStyle = .pageSheet
            present(searchVC, animated: true, completion: nil)
        }
    }
    
    func fetchCurrentLocation() {
        WeatherService().fetchCurrentLocation(latitude: lat, longitude: lat) { result in
            DispatchQueue.main.sync {
                self.stopActivityIndicator()
                switch result {
                case .success(let weather):
                    self.weatherModel = weather
                    self.updateLLabels()
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
    }
    
    @IBAction func searchCityButtonTapped(_ sender: UIButton) {
        presentSearchViewController()
    }
    
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        startActivityIndicator()
        fetchCurrentLocation()
       
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManger.stopUpdatingLocation()
            requestWeatherForLocation()
        }
    }
    
    func requestWeatherForLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        lat = Float(currentLocation.coordinate.latitude)
        lon = Float(currentLocation.coordinate.longitude)
        startActivityIndicator()
        fetchCurrentLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
        print(String(localized: "ERROR_IS") + " \(error)")
    }
}

extension WeatherViewController: SearchViewControllerDelegate {
    func fetchWeatherForCity(_ name: String) {
        startActivityIndicator()
        WeatherService().fetchWeatherForCity(name: name) { result in
            DispatchQueue.main.sync {
                self.stopActivityIndicator()
                switch result {
                case .success(let weather):
                    self.weatherModel = weather
                    self.updateLLabels()
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
    }
    
}
