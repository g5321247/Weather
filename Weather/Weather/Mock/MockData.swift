//
//  MockData.swift
//  Weather
//
//  Created by George Liu on 2019/5/9.
//  Copyright © 2019 George Liu. All rights reserved.
//

import Foundation

func getWeatherData() -> Data {
    let data = """
                    {
                    "coord": {
                    "lon": -0.13,
                    "lat": 51.51
                    },
                    "weather": [
                    {
                    "id": 522,
                    "main": "Rain",
                    "description": "heavy intensity shower rain",
                    "icon": "09d"
                    },
                    {
                    "id": 211,
                    "main": "Thunderstorm",
                    "description": "thunderstorm",
                    "icon": "11d"
                    }
                    ],
                    "base": "stations",
                    "main": {
                    "temp": 285.81,
                    "pressure": 991,
                    "humidity": 81,
                    "temp_min": 283.15,
                    "temp_max": 288.15
                    },
                    "visibility": 6000,
                    "wind": {
                    "speed": 4.6,
                    "deg": 290
                    },
                    "clouds": {
                    "all": 75
                    },
                    "dt": 1557334114,
                    "sys": {
                    "type": 1,
                    "id": 1502,
                    "message": 0.0118,
                    "country": "GB",
                    "sunrise": 1557289225,
                    "sunset": 1557344018
                    },
                    "id": 2643743,
                    "name": "London",
                    "cod": 200
                    }
                    """.data(using: .utf8)!
    return data
}

