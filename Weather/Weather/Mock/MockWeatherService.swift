//
//  MockWeatherService.swift
//  Weather
//
//  Created by george.liu on 2019/5/9.
//  Copyright © 2019 George Liu. All rights reserved.
//

import Foundation

class MockWeatherService: WeatherServiceSpec {
    
    private let error = NetworkError.invalidData
    private(set) var latitude: String?
    private(set) var longitude: String?
    
    func downloadWeather(cityName: String, completion: @escaping (Weather?, Error?) -> Void) {
        let weather = getWeather()
        
        completion(weather, error)
    }
    
    func downloadUVValue(latitude: String, longitude: String, completion: @escaping (UV?, Error?) -> Void) {
        let uv = getUV()
        
        completion(uv, error)
    }
}
