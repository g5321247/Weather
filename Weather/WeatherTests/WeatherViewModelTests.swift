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
        let expect = expectation(description: "123")

        let expectLatitude = "51.50"
        let expectLongitude = "-0.13"

        viewModel.getCoordinateFrom(address: "London") { (coordinate, _) in
            let latitude = String(format: "%.2f", coordinate!.latitude)
            let longitude = String(format: "%.2f", coordinate!.longitude)
            
            XCTAssert(expectLatitude == latitude)
            XCTAssert(expectLongitude == longitude)
            
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
}
