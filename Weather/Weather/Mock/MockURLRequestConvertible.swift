//
//  MockURLRequestConvertibleData.swift
//  Weather
//
//  Created by George Liu on 2019/5/9.
//  Copyright © 2019 George Liu. All rights reserved.
//

import Foundation

class MockURLRequestConvertible: URLRequestConvertible {
    var body: Data?
    
    var domain: String = ""
    
    var path: String = ""
    
    var method: APIMethod = .get
    
    var header: [String : String] = [:]
    
    var parameters: [String : Any] = [:]
}
