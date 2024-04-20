//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Sanat S Salian on 17/04/24.
//

import XCTest
@testable import WeatherApp

class WeatherModelTests: XCTestCase {
    
    func testWeatherModelProperties() {
        // Given
        let cityName = "London"
        let conditionID = 800
        let temperature: Float = 20.5
        let feelsLike: Float = 19.0
        let country: String = "JA"
        
        // When
        let weatherModel = WeatherModel(cityName: cityName, conditionID: conditionID, temperature: temperature, feelsLike: feelsLike, country: country)
        
        // Then
        XCTAssertEqual(weatherModel.cityName, cityName)
        XCTAssertEqual(weatherModel.conditionID, conditionID)
        XCTAssertEqual(weatherModel.temperature, temperature)
        XCTAssertEqual(weatherModel.feelsLike, feelsLike)
        XCTAssertEqual(weatherModel.temperatureString, "20.5")
        XCTAssertEqual(weatherModel.feelsLikeTemperatureString, "19.0")
        XCTAssertEqual(weatherModel.weatherCondition, "sun.max")
        XCTAssertEqual(weatherModel.country, "JA")
    }
}

class WeatherDataTests: XCTestCase {

    func testWeatherDataDecoding() {
        // Given
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
        
        // When
        do {
            let decoder = JSONDecoder()
            let weatherData = try decoder.decode(WeatherData.self, from: json)
            
            // Then
            XCTAssertEqual(weatherData.name, "London")
            XCTAssertEqual(weatherData.main.temp, 20.5)
            XCTAssertEqual(weatherData.main.feelsLike, 18.0)
            XCTAssertEqual(weatherData.weather.count, 1)
            XCTAssertEqual(weatherData.weather[0].id, 800)
            XCTAssertEqual(weatherData.sys.country, "JA")
        } catch {
            XCTFail("Failed to decode WeatherData: \(error)")
        }
    }

    func testMainDecoding() {
        // Given
        let json = """
        {
            "temp": 20.5,
            "feelsLike": 18.0
        }
        """.data(using: .utf8)!
        
        // When
        do {
            let decoder = JSONDecoder()
            let main = try decoder.decode(Main.self, from: json)
            
            // Then
            XCTAssertEqual(main.temp, 20.5)
            XCTAssertEqual(main.feelsLike, 18.0)
        } catch {
            XCTFail("Failed to decode Main: \(error)")
        }
    }
    
    func testMainDecodingWithError() {
        // Given
        let json = """
        {
            "temp": 20.5,
            "feelsLike": "18.0"
        }
        """.data(using: .utf8)!
        
        // When
        do {
            let decoder = JSONDecoder()
            let main = try decoder.decode(Main.self, from: json)
            
            // Then
            XCTAssertEqual(main.temp, 20.5)
            XCTAssertEqual(main.feelsLike, 18.0)
        } catch {
            XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it isn’t in the correct format.")
        }
    }
    
    func testWeatherDecoding() {
        // Given
        let json = """
        {
            "id": 800
        }
        """.data(using: .utf8)!
        
        // When
        do {
            let decoder = JSONDecoder()
            let weather = try decoder.decode(Weather.self, from: json)
            
            // Then
            XCTAssertEqual(weather.id, 800)
        } catch {
            XCTFail("Failed to decode Weather: \(error)")
        }
    }
}

class WeatherVCTests: XCTestCase {
    func test_Current_Location_API_Failure() {
        let mockService = MockWatherService()
        mockService.result = .failure(.DecodingError)
        let vc = WeatherViewController(weatherService: mockService)
        vc.fetchCurrentLocation()
        XCTAssertEqual(vc.weatherModel?.country, nil)
        XCTAssertNil(vc.weatherModel, "")
        
    }
    
    func test_Current_API_Success() {
        let mockService = MockWatherService()
        guard let weatherData = mockService.weatherData() else { return }
        mockService.result = .success(weatherData)
        let vc = WeatherViewController(weatherService: mockService)
        vc.fetchCurrentLocation()
        XCTAssertEqual(weatherData.cityName, "London")
        XCTAssertEqual(weatherData.conditionID, 800)
        XCTAssertEqual(weatherData.temperature, 20.5)
        XCTAssertEqual(weatherData.feelsLike, 18.0)
        XCTAssertEqual(weatherData.temperatureString, "20.5")
        XCTAssertEqual(weatherData.feelsLikeTemperatureString, "18.0")
        XCTAssertEqual(weatherData.weatherCondition, "sun.max")
        XCTAssertEqual(weatherData.country, "JA")
    }
    
    func test_City_Search_API_Failure() {
        let mockService = MockWatherService()
        mockService.result = .failure(.DecodingError)
        let vc = WeatherViewController(weatherService: mockService)
        vc.fetchWeatherForCity("London")
        XCTAssertEqual(vc.weatherModel?.country, nil)
        XCTAssertNil(vc.weatherModel, "")
        
    }
    
    func test_City_Search_API_Success() {
        let mockService = MockWatherService()
        guard let weatherData = mockService.weatherData() else { return }
        mockService.result = .success(weatherData)
        let vc = WeatherViewController(weatherService: mockService)
        vc.fetchWeatherForCity("London")
        XCTAssertEqual(weatherData.cityName, "London")
        XCTAssertEqual(weatherData.conditionID, 800)
        XCTAssertEqual(weatherData.temperature, 20.5)
        XCTAssertEqual(weatherData.feelsLike, 18.0)
        XCTAssertEqual(weatherData.temperatureString, "20.5")
        XCTAssertEqual(weatherData.feelsLikeTemperatureString, "18.0")
        XCTAssertEqual(weatherData.weatherCondition, "sun.max")
        XCTAssertEqual(weatherData.country, "JA")
    }
}
