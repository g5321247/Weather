//
//  MockURLSession.swift
//  Weather
//
//  Created by George Liu on 2019/5/8.
//  Copyright © 2019 George Liu. All rights reserved.
//

import Foundation

class MockURLSession: SessionProtocol {
    
    let nextDataTask = MockURLSessionDataTask()
    private(set)var request: URLRequest?
    var nextData: Data?
    var nextError: Error?
    var nextResponse: HTTPURLResponse?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping CompletionHandler) -> URLSessionDataTaskProtocol {
        
        self.request = request
        
        completionHandler(nextData, nextResponse, nextError)
        
        return nextDataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    
    private(set) var isCalled: Bool = false
    
    func resume() {
        isCalled = true
    }
}

extension HTTPURLResponse {
    convenience init?(statusCode: Int) {
        self.init(url: NSURL() as URL, statusCode: statusCode, httpVersion: nil, headerFields: nil)
    }
}
