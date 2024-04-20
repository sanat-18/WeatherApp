//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Sanat S Salian on 17/04/24.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    let sys: Sys
}

struct Main: Decodable {
    let temp: Float
    let feelsLike: Float
}

struct Weather: Decodable {
    let id: Int
}

struct Sys: Decodable {
    let country: String
}
