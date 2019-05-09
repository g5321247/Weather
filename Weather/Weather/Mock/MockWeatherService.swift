//
//  MockWeatherService.swift
//  Weather
//
//  Created by george.liu on 2019/5/9.
//  Copyright © 2019 George Liu. All rights reserved.
//

import Foundation

class MockWeatherService: WeatherServiceSpec {
    
    var nextData: Codable?
    var nextError: Error?
    private(set) var latitude: String?
    private(set) var longitude: String?
    
    func downloadWeather(cityName: String, completion: @escaping (Weather?, Error?) -> Void) {
        completion(nextData as? Weather, nextError)
    }
    
    func downloadUVValue(latitude: String, longitude: String, completion: @escaping (UV?, Error?) -> Void) {
        self.latitude = latitude
        self.longitude = longitude
        
        completion(nextData as? UV, nextError)
    }
}
