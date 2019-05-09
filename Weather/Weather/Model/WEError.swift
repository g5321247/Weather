//
//  WEError.swift
//  Weather
//
//  Created by George Liu on 2019/5/9.
//  Copyright © 2019 George Liu. All rights reserved.
//

import Foundation

enum NetworkError: Error, Equatable {
    case requestFailed
    case responseUnsuccessful(statusCode: Int)
    case invalidData
    case jsonParsingFailure
}

enum RouterError: Error {
    case cannotConvertToURL
    case cannotConvertToRequest
}
