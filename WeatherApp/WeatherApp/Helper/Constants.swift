//
//  Constants.swift
//  WeatherApp
//
//  Created by Sanat S Salian on 17/04/24.
//

import Foundation

var baseURL = "https://api.openweathermap.org/data/2.5/weather?appid="
var aPIKey = getAPIKey()
var kEmptyString = ""

func getAPIKey() -> String {
    if let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") {
        let plist = NSDictionary(contentsOfFile: filePath)
        let apiKey = plist?.object(forKey: "API_KEY") as? String ?? kEmptyString
        return apiKey
    }
    return kEmptyString
}
