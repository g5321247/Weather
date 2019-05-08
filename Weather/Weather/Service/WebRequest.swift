//
//  Service.swift
//  Weather
//
//  Created by George Liu on 2019/5/7.
//  Copyright © 2019 George Liu. All rights reserved.
//

import Foundation

enum NetworkError: Error, Equatable {
    case requestFailed
    case responseUnsuccessful(statusCode: Int)
    case invalidData
    case jsonParsingFailure
}

protocol WebRequestSpec {
    func request<T: Codable>(request: URLRequest, compltion: @escaping (T?, Error?) -> Void)
}

class WebRequest: WebRequestSpec {
    
    fileprivate let session: SessionProtocol
    fileprivate let decoder: JSONDecoder = JSONDecoder()
    
    init(session: SessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func request<T: Codable>(request: URLRequest, compltion: @escaping (T?, Error?) -> Void) {
        
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
}
