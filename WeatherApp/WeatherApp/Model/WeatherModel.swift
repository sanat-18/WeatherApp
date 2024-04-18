//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Sanat S Salian on 17/04/24.
//

import Foundation

struct WeatherModel {
    let cityName: String
    let conditionID: Int
    let temperature: Float
    let feelsLike: Float
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var feelsLikeTemperatureString: String {
        return String(format: "%.1f", feelsLike)
    }
    
    var weatherCondition: String {
        switch conditionID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
