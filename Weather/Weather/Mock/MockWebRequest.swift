//
//  MockWebRequest.swift
//  Weather
//
//  Created by George Liu on 2019/5/9.
//  Copyright © 2019 George Liu. All rights reserved.
//

import Foundation

class MockWebRequest: WebRequestSpec {

    var nextResult: Codable?
    var nextError: Error?
    private(set) var isCalled: Bool = false

    func download<T>(model: URLRequestConvertible, completion: @escaping (T?, Error?) -> Void) {
        isCalled = true
        completion(nextResult as? T, nextError)
    }
}
