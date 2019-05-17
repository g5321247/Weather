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

    func handleRequest<T>(model: URLRequestConvertible, compltion: @escaping (T?, Error?) -> Void) {
        isCalled = true
        compltion(nextResult as? T, nextError)
    }
}
