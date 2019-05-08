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

class WeatherService: WeatherServiceSpec {
    
    private let service: WebRequestSpec
    
    init(service: WebRequestSpec = WebRequest()) {
        self.service = service
    }
    
    func downloadWeather(cityName: String, completion: @escaping (Weather?, Error?) -> Void) {
        let router: Router = .currentWeather(cityName)
        let request = try? router.getRequest()
        
        service.request(request: request!, compltion: completion)
    }
    
    func downloadUVValue(latitude: String, longitude: String, completion: @escaping (UV?, Error?) -> Void) {
        let router: Router = .uvValue(latitude, longitude)
        let request = try? router.getRequest()
        
        service.request(request: request!, compltion: completion)
    }
}
