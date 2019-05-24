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
    func testCityNameBeforeSendingRequest() {
        let city = "London"
        let expectCity = "London"
        
        viewModel = WeatherViewModel(service: service, cityName: city, type: .currentWeather, geocoder: geocoder)

        viewModel.checkWeatherCondition()
        
        XCTAssert(service.cityName == expectCity, "request city incorrect")
    }
    
    func testCurrentWeatherIfHandleSuccess() {
        service.nextWeather = getWeather()
        
        let expect = expectation(description: "get current weather")
        let expectWeather = Weather(main: Main(temp: 285.81), name: "London", cod: 200)
        var outputs = viewModel.outputs
        
        outputs.weather = { (weather) in
            XCTAssert(expectWeather == weather, "current weather incorrect")
            expect.fulfill()
        }
        
        viewModel.inputs.checkWeatherCondition()
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testErrorMessageIfServiceFailed() {
        service.nextError = NetworkError.invalidData
        
        let expect = expectation(description: "get error of invalidData")
        let expectErrorMessage = NetworkError.invalidData.localizedDescription
        var outputs = viewModel.outputs
        
        outputs.error = { (errorMessage) in
            XCTAssert(expectErrorMessage == errorMessage, "error message incorrect")
            expect.fulfill()
        }
        
        viewModel.inputs.checkWeatherCondition()
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testNoErrorMessageIfServiceFailed() {
        var outputs = viewModel.outputs
        
        let expect = expectation(description: "get unexpected error Messgae")
        let expectErrorMessage = ""
        
        outputs.error = { (errorMessage) in
            XCTAssert(expectErrorMessage == errorMessage, "error message incorrect")
            expect.fulfill()
        }
        
        viewModel.inputs.checkWeatherCondition()
        waitForExpectations(timeout: 10, handler: nil)
    }

    
    // UV
    func testCityNameBeforeTransformCoordinate() {
        let city = "London"
        let expectCity = "London"
        
        viewModel = WeatherViewModel(service: service, cityName: city, type: .uvValue, geocoder: geocoder)
        
        viewModel.checkWeatherCondition()
        
        XCTAssert(geocoder.cityName == expectCity, "request city incorrect")
    }

    func testLocationStrBeforeSendingRequest() {
        viewModel = WeatherViewModel(service: service, cityName: "London", type: .uvValue, geocoder: geocoder)
        
        let expectLatitude = "51.50"
        let expectLongitude = "-0.13"
        
        geocoder.nextLocationString = ("51.50", "-0.13")
        viewModel.checkWeatherCondition()
        
        XCTAssert(service.latitude == expectLatitude, "latitude incorrect")
        XCTAssert(service.longitude == expectLongitude, "longitude incorrect")
    }

    func testErrorMessageIfTransformCoordinateFailed() {
        viewModel = WeatherViewModel(service: service, cityName: "London", type: .uvValue, geocoder: geocoder)
        geocoder.nextError = ConvertError.address
        
        let expectErrorMessage = ConvertError.address.localizedDescription
        var outputs = viewModel.outputs

        outputs.error = { (errorMessage) in
            XCTAssert(expectErrorMessage == errorMessage, "error message incorrect")
        }

        viewModel.inputs.checkWeatherCondition()
    }
    
    func testNilErrorMessageIfTransformCoordinateFailed() {
        viewModel = WeatherViewModel(service: service, cityName: "London", type: .uvValue, geocoder: geocoder)
        
        let expectErrorMessage = ""
        var outputs = viewModel.outputs
        
        outputs.error = { (errorMessage) in
            XCTAssert(expectErrorMessage == errorMessage, "error message incorrect")
        }
        
        viewModel.inputs.checkWeatherCondition()
    }

    func testUVValueIfHandleSuccess() {
        viewModel = WeatherViewModel(service: service, cityName: "London", type: .uvValue, geocoder: geocoder)

        geocoder.nextLocationString = ("51.50", "-0.13")
        service.nextUV = getUV()
        
        let expect = expectation(description: "get uv")
        let expectUV = UV(value: 4.24)
        var outputs = viewModel.outputs
        
        outputs.uvValue = { (uv) in
            XCTAssert(expectUV == uv, "uv incorrect")
            expect.fulfill()
        }
        
        viewModel.inputs.checkWeatherCondition()
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testErrorMessageIfIfServiceFailed() {
        viewModel = WeatherViewModel(service: service, cityName: "London", type: .uvValue, geocoder: geocoder)
        geocoder.nextLocationString = ("51.50", "-0.13")
        service.nextError = NetworkError.invalidData
        
        let expect = expectation(description: "get unexpected error Messgae")
        let expectErrorMessage = NetworkError.invalidData.localizedDescription
        var outputs = viewModel.outputs
        
        outputs.error = { (errorMessage) in
            XCTAssert(expectErrorMessage == errorMessage, "error message incorrect")
            expect.fulfill()
        }
        
        viewModel.inputs.checkWeatherCondition()
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testNilErrorMessageIfServiceFailed() {
        viewModel = WeatherViewModel(service: service, cityName: "London", type: .uvValue, geocoder: geocoder)
        geocoder.nextLocationString = ("51.50", "-0.13")
        
        let expect = expectation(description: "get unexpected error Messgae")
        let expectErrorMessage = ""
        var outputs = viewModel.outputs
        
        outputs.error = { (errorMessage) in
            XCTAssert(expectErrorMessage == errorMessage, "error message incorrect")
            expect.fulfill()
        }
        
        viewModel.inputs.checkWeatherCondition()
        waitForExpectations(timeout: 10, handler: nil)
    }

}
