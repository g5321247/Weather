//
//  Router.swift
//  Weather
//
//  Created by George Liu on 2019/5/8.
//  Copyright © 2019 George Liu. All rights reserved.
//

import Foundation

protocol URLRequestConvertible {
    var domain: String { get }
    var path: String { get }
    var method: APIMethod { get }
    var header: [String: String] { get }
    var parameters: [String: Any] { get }
//    var body
}

enum Router {
    case currentWeather(String)
    case uvValue(String, String)
}

extension Router: URLRequestConvertible {
    
    var domain: String {
        return "https://api.openweathermap.org"        
    }
    
    var path: String {
        switch self {
        case .currentWeather:
            return "/data/2.5/weather"
        case .uvValue:
            return "/data/2.5/uvi"
        }
    }
    
    var method: APIMethod {
        switch self {
        case .currentWeather, .uvValue:
            return .get
        }
    }
    
    var header: [String : String] {
        return [:]
    }
    
    var parameters: [String : Any] {
        var params: [String: Any] = [:]
        params["APPID"] = "43d848999087841b1476fb020ee1d2f8"

        switch self {
        case .currentWeather(let city):
            params["q"] = city
        case .uvValue(let lat, let lon):
            params["lat"] = lat
            params["lon"] = lon
        }
        
        return params
    }
}

enum APIMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
