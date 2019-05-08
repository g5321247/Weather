//
//  Pollution.swift
//  Weather
//
//  Created by George Liu on 2019/5/8.
//  Copyright © 2019 George Liu. All rights reserved.
//

import Foundation

struct Pollution: Codable {
    let data: [Datum]
}

struct Datum: Codable {
    let pressure: Double
}
