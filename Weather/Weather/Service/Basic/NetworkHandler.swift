//
//  Service.swift
//  Weather
//
//  Created by George Liu on 2019/5/7.
//  Copyright © 2019 George Liu. All rights reserved.
//

import Foundation

protocol NetworkHandlerSpec {
    func download<T: Codable>(model: URLRequestConvertible, completion: @escaping (T?, Error?) -> Void)
    func cancelDownload()
}

final class NetworkHandler: NetworkHandlerSpec {
    
    private let session: SessionProtocol
    private let decoder: JSONDecoder = JSONDecoder()
    private var dataTask: URLSessionDataTaskProtocol?
    
    init(session: SessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func download<T: Codable>(model: URLRequestConvertible, completion: @escaping (T?, Error?) -> Void) {
        do {
            let request = try getRequest(model: model)
            sendRequest(request: request) { [weak self] (data, error) in
                guard let data = data else {
                    completion(nil, error)
                    return
                }
                self?.parseResult(data: data, completion: completion)
            }
        } catch {
            completion(nil, error)
        }
    }
    
    func cancelDownload() {
        dataTask?.cancel()
    }
}

extension NetworkHandler {
    
    func sendRequest(request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        dataTask = session.dataTask(with: request) { (data, response, error) in
            defer { self.dataTask = nil }
            
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(nil, NetworkError.requestFailed)
                return
            }
            
            guard 200 ... 299 ~= response.statusCode else {
                completion(nil, NetworkError.responseUnsuccessful(statusCode: response.statusCode))
                return
            }
            
            guard let data = data else {
                completion(nil, NetworkError.invalidData)
                return
            }
            
            completion(data, nil)
        }
        
        dataTask?.resume()
    }
    
    func parseResult<T: Codable>(data: Data, completion: @escaping (T?, Error?) -> Void) {
        do {
            let result = try decoder.decode(T.self, from: data)
            completion(result, nil)
        } catch {
            completion(nil, NetworkError.jsonParsingFailure)
        }
    }
    
    func getURL(model: URLRequestConvertible) throws -> URL {
        let uri = model.domain + model.path
        guard let url = URL(string: uri) else {
            throw ConvertError.url
        }
        return url
    }
    
    func getRequest(model: URLRequestConvertible) throws -> URLRequest {
        do {
            var url = try getURL(model: model) // url
            configureParameters(url: &url, with: model.parameters)  // param: encode + components
            var request = URLRequest(url: url) // request
            request.httpMethod = model.method.rawValue  // method
            request.allHTTPHeaderFields = model.header  // header
            request.httpBody = model.body
            
            return request
        } catch {
            throw error
        }
    }
    
    // parameters: encode & added
    func configureParameters(url: inout URL, with parameters: [String: Any]) {
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            
            for item in parameters {
                let queryItem = URLQueryItem(
                    name: item.key,
                    value: "\(item.value)"//.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                )
                urlComponents.queryItems?.append(queryItem)
            }
            url = urlComponents.url ?? url
        }
    }
}
