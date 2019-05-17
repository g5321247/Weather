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

    private let requestor: WebRequestSpec

    init(requestor: WebRequestSpec = WebRequest()) {
        self.requestor = requestor
    }

    func downloadWeather(cityName: String, completion: @escaping (Weather?, Error?) -> Void) {
        let router: Router = .currentWeather(cityName)
        requestor.sendRequest(model: router, compltion: completion)
    }

    func downloadUVValue(latitude: String, longitude: String, completion: @escaping (UV?, Error?) -> Void) {
        let router: Router = .uvValue(latitude, longitude)
        requestHandler(router: router, completion: completion)
    }

    private func requestHandler<T: Codable>(router: Router, completion: @escaping (T?, Error?) -> Void) {
        requestor.handleRequest(model: router, compltion: completion)
    }
}
