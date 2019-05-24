//
//  MockWeatherService.swift
//  Weather
//
//  Created by george.liu on 2019/5/9.
//  Copyright © 2019 George Liu. All rights reserved.
//

import Foundation

class MockWeatherService: WeatherServiceSpec {
    
    var nextError: Error?
    var nextWeather: Weather?
    var nextUV: UV?
    private(set) var latitude: String?
    private(set) var longitude: String?
    private(set) var isCalled: Bool = false
    
    func downloadWeather(cityName: String, completion: @escaping (Weather?, Error?) -> Void) {
        isCalled = true
        
        completion(nextWeather, nextError)
    }
    
    func downloadUVValue(latitude: String, longitude: String, completion: @escaping (UV?, Error?) -> Void) {
        isCalled = true
        
        self.latitude = latitude
        self.longitude = longitude
                
        completion(nextUV, nextError)
    }
}
