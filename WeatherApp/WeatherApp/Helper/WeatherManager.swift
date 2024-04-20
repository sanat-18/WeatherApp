//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Sanat S Salian on 17/04/24.
//

import UIKit

enum DemoError: Error {
    case BadURL
    case NoData
    case DecodingError
}

class WeatherManager {
    let apiHandler: APIHandler
    let responseHandler: ResponseHandler
    
    init(apiHandler: APIHandler = APIHandler(),
         responseHandler: ResponseHandler = ResponseHandler()){
        self.apiHandler = apiHandler
        self.responseHandler = responseHandler
    }
    
    func fetchCurrentLocation(latitude lat: Float, longitude lon: Float, completion: @escaping (Result<WeatherModel, DemoError>) -> Void) -> Void {
        guard let url = URL(string: baseURL + aPIKey + "&units=metric&lat=\(lat)&lon=\(lon)") else {
            return completion(.failure(.BadURL))
        }
        apiHandler.fetchCurrentLocation(url: url) { result in
            switch result {
            case .success(let data):
                self.responseHandler.fetchWeatherData(data: data) { decodedData in
                    switch decodedData {
                    case .success(let model):
                        completion(.success(model))
                    case .failure(_):
                        completion(.failure(.DecodingError))
                    }
                }
            case .failure(_):
                print("")
            }
        }
        
    }
        
    func fetchWeatherForCity(name: String, completion: @escaping (Result<WeatherModel, DemoError>) -> Void) -> Void {
        guard let url = URL(string: baseURL + aPIKey + "&units=metric&q=\(name)") else {
            return completion(.failure(.BadURL))
        }
        apiHandler.fetchCurrentLocation(url: url) { result in
            switch result {
            case .success(let data):
                self.responseHandler.fetchWeatherData(data: data) { decodedData in
                    switch decodedData {
                    case .success(let model):
                        completion(.success(model))
                    case .failure(_):
                        completion(.failure(.DecodingError))
                    }
                }
            case .failure(_):
                print("")
            }
        }
    }
}

protocol WeatherServiceDelegate {
    func fetchCurrentLocation(latitude lat: Float, longitude lon: Float, completion: @escaping (Result<WeatherModel, DemoError>) -> Void) -> Void
    func fetchWeatherForCity(name: String, completion: @escaping (Result<WeatherModel, DemoError>) -> Void) -> Void
}

class WeatherService: WeatherServiceDelegate {
    func fetchCurrentLocation(latitude lat: Float, longitude lon: Float, completion: @escaping (Result<WeatherModel, DemoError>) -> Void) -> Void {
        WeatherManager().fetchCurrentLocation(latitude: lat, longitude: lon, completion: completion)
    }
    
    func fetchWeatherForCity(name: String, completion: @escaping (Result<WeatherModel, DemoError>) -> Void) -> Void {
        WeatherManager().fetchWeatherForCity(name: name, completion: completion)
    }
}
