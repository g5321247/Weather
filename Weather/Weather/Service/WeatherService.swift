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

final class WeatherService: BaseService, WeatherServiceSpec {

    func downloadWeather(cityName: String, completion: @escaping (Weather?, Error?) -> Void) {
        let api: APIModel = .currentWeather(cityName)
        download(apiModel: api, completion: completion)
    }

    func downloadUVValue(latitude: String, longitude: String, completion: @escaping (UV?, Error?) -> Void) {
        let api: APIModel = .uvValue(latitude, longitude)
        download(apiModel: api, completion: completion)
    }
}
