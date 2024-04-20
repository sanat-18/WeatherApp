//
//  MockWatherService.swift
//  WeatherAppTests
//
//  Created by Sanat S Salian on 20/04/24.
//

import Foundation
@testable import WeatherApp

class MockWatherService: WeatherServiceDelegate {
    var result: Result<WeatherModel, DemoError>!
    func fetchCurrentLocation(latitude lat: Float, longitude lon: Float, completion: @escaping (Result<WeatherModel, DemoError>) -> Void) {
        completion(result)
    }
    
    func fetchWeatherForCity(name: String, completion: @escaping (Result<WeatherModel, DemoError>) -> Void) {
        completion(result)
    }
    
    func weatherData() -> WeatherModel? {
        let json = """
        {
            "name": "London",
            "main": {
                "temp": 20.5,
                "feelsLike": 18.0
            },
            "weather": [
                {
                    "id": 800
                }
            ],
            "sys" : {
                "country" : "JA"
            }
        
        }
        """.data(using: .utf8)!
        
        do {
            let obj = try JSONDecoder().decode(WeatherData.self, from: json)
            let name = obj.name
            let id = obj.weather[0].id
            let temp = obj.main.temp
            let feelsLike = obj.main.feelsLike
            let country = obj.sys.country
            let weatherModel = WeatherModel(cityName: name, conditionID: id, temperature: temp, feelsLike: feelsLike, country: country)
            return weatherModel
            
        } catch {
            return nil
        }
    }
}
