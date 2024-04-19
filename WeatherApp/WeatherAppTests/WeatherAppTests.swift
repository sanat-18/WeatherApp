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
        
        // When
        let weatherModel = WeatherModel(cityName: cityName, conditionID: conditionID, temperature: temperature, feelsLike: feelsLike)
        
        // Then
        XCTAssertEqual(weatherModel.cityName, cityName)
        XCTAssertEqual(weatherModel.conditionID, conditionID)
        XCTAssertEqual(weatherModel.temperature, temperature)
        XCTAssertEqual(weatherModel.feelsLike, feelsLike)
        XCTAssertEqual(weatherModel.temperatureString, "20.5")
        XCTAssertEqual(weatherModel.feelsLikeTemperatureString, "19.0")
        XCTAssertEqual(weatherModel.weatherCondition, "sun.max")
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
            ]
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

class WeatherManagerTests: XCTestCase {
    
    class MockDelegate: WeatherManagerDelegate {
        var updateWeatherCalled = false
        var error: Error?
        var weather: WeatherModel?
        
        func didUpdateWeatherManager(_ weather: WeatherModel) {
            updateWeatherCalled = true
            self.weather = weather
        }
        
        func didFailWithError(error: Error) {
            self.error = error
        }
    }
    
    func testFetchCityWeather() {
        // Given
        let manager = WeatherManager.sharedManager
        let mockDelegate = MockDelegate()
        manager.delegate = mockDelegate
        let cityName = "London"
        
        // When
        manager.fetchCityWeather(cityName)
        
        // Then
        XCTAssertNotNil(manager.delegate)
        XCTAssertNotNil(manager.delegate === mockDelegate)
    }
    
    func testFetchCurrentWeather() {
        // Given
        let manager = WeatherManager.sharedManager
        let mockDelegate = MockDelegate()
        manager.delegate = mockDelegate
        let latitude: Float = 50.5074
        let longitude: Float = 13.1278
        
        // When
        manager.fetchCurrentWeather(latitude: latitude, longitude: longitude)
        
        // Then
        XCTAssertNotNil(manager.delegate)
        XCTAssertNotNil(manager.delegate === mockDelegate)
    }
    
    func testParseJson() {
        // Given
        let manager = WeatherManager.sharedManager
        let mockDelegate = MockDelegate()
        manager.delegate = mockDelegate
        
        // Sample JSON data
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
            ]
        }
        """.data(using: .utf8)!
        
        // When
        let weatherModel = manager.parseJson(json)
        
        // Then
        XCTAssertNotNil(weatherModel)
        XCTAssertEqual(weatherModel?.cityName, "London")
        XCTAssertEqual(weatherModel?.conditionID, 800)
        XCTAssertEqual(weatherModel?.temperature, 20.5)
        XCTAssertEqual(weatherModel?.feelsLike, 18.0)
    }
}
