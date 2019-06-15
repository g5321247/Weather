//
//  BaseService.swift
//  Weather
//
//  Created by George Liu on 2019/6/15.
//  Copyright © 2019 George Liu. All rights reserved.
//

import Foundation

class BaseService {
    
    private let networkHandler: NetworkHandlerSpec
    
    init(networkHandler: NetworkHandlerSpec = NetworkHandler()) {
        self.networkHandler = networkHandler
    }
    
    func download<T: Codable>(apiModel: APIModel, completion: @escaping (T?, Error?) -> Void) {
        networkHandler.download(apiModel: apiModel, completion: completion)
    }
}
