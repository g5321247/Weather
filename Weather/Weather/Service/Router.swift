//
//  Router.swift
//  Weather
//
//  Created by George Liu on 2019/5/8.
//  Copyright © 2019 George Liu. All rights reserved.
//

import Foundation

enum RouterError: Error {
    case cannotConvertToURL
    case cannotConvertToRequest
}

protocol URLRequestConvertible {
    var domain: String { get }
    var path: String { get }
    var method: APIMethod { get }
    var header: [String: String] { get }
    var parameters: [String: Any] { get }
    
    func getURL() throws -> URL
    func getRequest() throws -> URLRequest
}

enum Router {
    case currentWeather(String)
    case uvValue(String,String)
}

extension Router: URLRequestConvertible {
    
    var domain: String {
        return "https://api.openweathermap.org"        
    }
    
    var path: String {
        switch self {
        case .currentWeather:
            return "/data/2.5/weather"
        case .uvValue(let lat, let lon):
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
    
    func getURL() throws -> URL {
        let uri = domain + path
        guard let url = URL(string: uri) else {
            throw RouterError.cannotConvertToURL
        }
        return url
    }
    
    func getRequest() throws -> URLRequest {
        do {
            var url = try getURL() // url
            encode(url: &url, with: parameters)  // param: encode + components
            var request = URLRequest(url: url) // request
            request.httpMethod = method.rawValue  // method
            request.allHTTPHeaderFields = header  // header
            
            return request
        } catch {
            throw error
        }
    }
}

extension Router {
    // parameters: encode & added
    private func encode(url: inout URL, with parameters: [String: Any]) {
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            
            urlComponents.queryItems = [URLQueryItem]()
            
            for item in parameters {
                let queryItem = URLQueryItem(
                    name: item.key,
                    value: "\(item.value)")
                
                urlComponents.queryItems?.append(queryItem)
            }
            url = urlComponents.url ?? url
        }
    }
}

enum APIMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
