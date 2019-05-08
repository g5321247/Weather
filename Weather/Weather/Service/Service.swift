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

protocol ServiceSpec {
    func request<T: Codable>(_ router: Router, compltion: @escaping (T?, Error?) -> Void)
}

extension ServiceSpec where Self: Service {
    
    func request<T: Codable>(_ router: Router, compltion: @escaping (T?, Error?) -> Void) {
        
        do {
            let request = try router.getRequest()
            
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
                    print(result)
                    compltion(result, nil)
                } catch {
                    compltion(nil, NetworkError.jsonParsingFailure)
                }
            }

            dataTask.resume()

        } catch {
             compltion(nil, error)
        }
    }
}

class Service: ServiceSpec {
    
    fileprivate let session: URLSession
    fileprivate let decoder: JSONDecoder = JSONDecoder()
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}
