//
//  Service.swift
//  Weather
//
//  Created by George Liu on 2019/5/7.
//  Copyright © 2019 George Liu. All rights reserved.
//

import Foundation


protocol WebRequestSpec {
    func sendRequest<T: Codable>(model: URLRequestConvertible, compltion: @escaping (T?, Error?) -> Void)
}

class WebRequest: WebRequestSpec {
    
    fileprivate let session: SessionProtocol
    fileprivate let decoder: JSONDecoder = JSONDecoder()
    
    init(session: SessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func sendRequest<T: Codable>(model: URLRequestConvertible, compltion: @escaping (T?, Error?) -> Void) {
       
        do {
            let request = try getRequest(model: model)
            sendRequest(request: request, compltion: compltion)
        } catch {
            compltion(nil, error)
        }
    }
    
    func sendRequest<T: Codable>(request: URLRequest, compltion: @escaping (T?, Error?) -> Void) {
        
        do {
            
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    compltion(nil, error!)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    compltion(nil, NetworkError.requestFailed)
                    return
                }
                
                guard 200 ... 299 ~= response.statusCode else {
                    compltion(nil, NetworkError.responseUnsuccessful(statusCode: response.statusCode))
                    return
                }
                
                guard let data = data else {
                    compltion(nil, NetworkError.invalidData)
                    return
                }
                
                do {
                    let result = try self.decoder.decode(T.self, from: data)
                    compltion(result, nil)
                } catch {
                    compltion(nil, NetworkError.jsonParsingFailure)
                }
            }
            
            dataTask.resume()
        }
    }
    
    func getURL(model: URLRequestConvertible) throws -> URL {
        let uri = model.domain + model.path
        guard let url = URL(string: uri) else {
            throw RouterError.cannotConvertToURL
        }
        return url
    }
    
    func getRequest(model: URLRequestConvertible) throws -> URLRequest {
        do {
            var url = try getURL(model: model) // url
            encode(url: &url, with: model.parameters)  // param: encode + components
            var request = URLRequest(url: url) // request
            request.httpMethod = model.method.rawValue  // method
            request.allHTTPHeaderFields = model.header  // header
            
            return request
        } catch {
            throw RouterError.cannotConvertToRequest
        }
    }
}

extension WebRequest {
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
