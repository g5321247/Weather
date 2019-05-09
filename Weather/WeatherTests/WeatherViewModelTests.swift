//
//  WeatherViewModelTests.swift
//  WeatherTests
//
//  Created by george.liu on 2019/5/9.
//  Copyright © 2019 George Liu. All rights reserved.
//

import XCTest
@testable import Weather

class WeatherViewModelTests: XCTestCase {

    var viewModel: WeatherViewModel!
    var service = MockWeatherService()
    
    override func setUp() {
        viewModel = WeatherViewModel(service: service, cityName: "London", type: .currentWeather)
    }

    override func tearDown() {
        viewModel = nil
    }
    
    // Current Weather
    func testCurrentWeatherIfHandleSuccess() {
        
    }
    
    // UV
    func testLocationConvert() {
        
        viewModel = WeatherViewModel(service: service, cityName: "London", type: .uvValue)

        
        viewModel.inputs.searchCityWeather()
    }
}
