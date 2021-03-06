//
//  aaa.swift
//  Weather
//
//  Created by george.liu on 2019/5/8.
//  Copyright © 2019 George Liu. All rights reserved.
//

import Foundation

struct Weather: Codable, Equatable {
    static func == (lhs: Weather, rhs: Weather) -> Bool {
        return true
    }
    
    let main: Main
    let name: String
    let cod: Int
}

struct Main: Codable {
    let temp: Double
}
