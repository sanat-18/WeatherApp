//
//  APIHandler.swift
//  WeatherApp
//
//  Created by Sanat S Salian on 20/04/24.
//

import Foundation

class APIHandler {
    func fetchCurrentLocation(url: URL, completion: @escaping (Result<Data, DemoError>) -> Void) -> Void {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) {(data, response, error) in
            guard let data = data, error == nil else {
                return completion(.failure(.NoData))
            }
            completion(.success(data))
        }
        
        task.resume()
    }
}
