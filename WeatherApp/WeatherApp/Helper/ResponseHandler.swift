//
//  ResponseHandler.swift
//  WeatherApp
//
//  Created by Sanat S Salian on 20/04/24.
//

import Foundation

class ResponseHandler {
    func fetchWeatherData(data: Data, completion: @escaping (Result<WeatherModel, DemoError>) -> Void) -> Void {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let decodedData = try? decoder.decode(WeatherData.self, from: data)
        if let decodedData = decodedData {
            let name = decodedData.name
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let feelsLike = decodedData.main.feelsLike
            let country = decodedData.sys.country

            let weatherModel = WeatherModel(cityName: name, conditionID: id, temperature: temp, feelsLike: feelsLike, country: country)
            
            completion(.success(weatherModel))
        } else {
            completion(.failure(.DecodingError))
        }
    }
}
