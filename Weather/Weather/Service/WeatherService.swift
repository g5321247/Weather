//
//  WeatherService.swift
//  Weather
//
//  Created by George Liu on 2019/5/7.
//  Copyright © 2019 George Liu. All rights reserved.
//

import Foundation

protocol WeatherServiceSpec {
    func downloadWeather(cityName: String, completion: @escaping (Weather?, Error?) -> Void)
    func downloadUVValue(latitude: String, longitude: String, completion: @escaping (UV?, Error?) -> Void)

}

class WeatherService: Service, WeatherServiceSpec {
    
    func downloadWeather(cityName: String, completion: @escaping (Weather?, Error?) -> Void) {
        
        request(.currentWeather(cityName), compltion: completion)
    }
    
    func downloadUVValue(latitude: String, longitude: String, completion: @escaping (UV?, Error?) -> Void) {
        
        request(.uvValue(latitude, longitude), compltion: completion)
    }
}
