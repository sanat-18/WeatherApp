//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Sanat S Salian on 17/04/24.
//

import UIKit

protocol WeatherManagerDelegate: AnyObject {
    func didUpdateWeatherManager(_ weather: WeatherModel)
    func didFailWithError(error: Error)
}

final class WeatherManager {
    
    static let sharedManager = WeatherManager()
    weak var delegate: WeatherManagerDelegate?
    
    private  init(delegate: WeatherManagerDelegate? = nil) {
        self.delegate = delegate
    }
    
    func fetchCityWeather(_ name: String) {
        let urlString = baseURL + aPIKey + "&units=metric&q=\(name)"
        performRequest(urlString: urlString)
    }
    
    func fetchCurrentWeather(latitude lat: Float, longitude lon: Float) {
        let urlString = baseURL + aPIKey + "&units=metric&lat=\(lat)&lon=\(lon)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { [weak self] (data, response, error) in
                if error != nil {
                    self?.delegate?.didFailWithError(error: error!)
                }
                
                if let safeData = data {
                    if let weather = self?.parseJson(safeData) {
                        self?.delegate?.didUpdateWeatherManager(weather)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJson(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodedData.name
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let feelsLike = decodedData.main.feelsLike
            
            return WeatherModel(cityName: name, conditionID: id, temperature: temp, feelsLike: feelsLike)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
