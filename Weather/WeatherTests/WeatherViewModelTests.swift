//
//  WeatherViewModelTests.swift
//  WeatherTests
//
//  Created by george.liu on 2019/5/9.
//  Copyright © 2019 George Liu. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Weather

class WeatherViewModelTests: XCTestCase {

    var viewModel: WeatherViewModel!
    let service = MockWeatherService()
    let geocoder = MockCLGeocoder()
    
    override func setUp() {
        viewModel = WeatherViewModel(service: service, cityName: "London", type: .currentWeather, geocoder: geocoder)
    }

    override func tearDown() {
        viewModel = nil
    }
    
    // Check Download Function is Called
    func testDownloadFunctionIfTypeIsCurrentWeather() {
        viewModel.inputs.checkWeatherCondition()
        
        XCTAssertTrue(service.isCalled, "downloadCurrentWeather isn't called")
    }
    
    func testDownloadFunctionIfTypeIsUvValue() {
        viewModel = WeatherViewModel(service: service, cityName: "London", type: .uvValue, geocoder: geocoder)
        geocoder.nextLocationString = ("51.50", "-0.13")
        
        viewModel.inputs.checkWeatherCondition()
        
        XCTAssertTrue(service.isCalled, "downloadUV isn't called")
    }
    
    // Current Weather
    func testCurrentWeatherIfHandleSuccess() {
        
        viewModel.outputs.weather
        
        viewModel.inputs.checkWeatherCondition()
    }
    
    // UV
//    func testAddressStr() {
//        let mockCLGeocoder = MockCLGeocoder()
//        viewModel = WeatherViewModel(service: service, cityName: "London", type: .uvValue,geocoder: mockCLGeocoder)
//        let expect = expectation(description: "Get Coordinate")
//
//        let expectLatitude = "51.50"
//        let expectLongitude = "-0.13"
//
//        viewModel.getCoordinateFrom(address: "London") { (coordinate, _) in
//            let latitude = String(format: "%.2f", coordinate!.latitude)
//            let longitude = String(format: "%.2f", coordinate!.longitude)
//            
//            XCTAssert(expectLatitude == latitude)
//            XCTAssert(expectLongitude == longitude)
//            
//            expect.fulfill()
//        }
//        
//        waitForExpectations(timeout: 10, handler: nil)
//    }
//    
//    func testDownloadUVIfSuccess() {
//        let mockCLGeocoder = MockCLGeocoder()
//        let dummyCLPlacemark = CLPlacemark()
//        mockCLGeocoder.nextCLPlacemarks = [dummyCLPlacemark]
//
//        viewModel = WeatherViewModel(service: service, cityName: "London", type: .uvValue, geocoder: mockCLGeocoder)
//        
//        var outputs = viewModel.outputs
//        let expectModel = getUV()
//        
//        outputs.uvValue = { (uv) in
//            XCTAssert(uv != expectModel, "UV Model is invalid")
//        }
//        
//        viewModel.inputs.checkWeatherCondition()
//    }
    
}
