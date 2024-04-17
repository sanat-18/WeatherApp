//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Sanat S Salian on 17/04/24.
//

import UIKit


protocol WeatherManagerDelegate {
    func didUpdateWeatherManager(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherManager {
    var delegate: WeatherManagerDelegate?
    
    func fetchCityWeather(_ name: String) {
        let urlString = BaseURL + APIKey + "&q=\(name)"
        performRequest(urlString: urlString)
    }
    
    func fetchCurrentWeather(latitude lat: Float, longitude lon: Float) {
        let urlString = BaseURL + APIKey + "&units=metric&lat=\(lat)&lon=\(lon)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString : String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                }
                
                if let safeData = data {
                    if let weather = parseJson(safeData) {
                        delegate?.didUpdateWeatherManager(self, weather: weather)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    
    func parseJson(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let name = decodedData.name
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            
            return WeatherModel(cityName: name, conditionID: id, temperature: temp)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
