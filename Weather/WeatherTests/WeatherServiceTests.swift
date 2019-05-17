//
//  WeatherServiceTests.swift
//  WeatherTests
//
//  Created by George Liu on 2019/5/9.
//  Copyright © 2019 George Liu. All rights reserved.
//

import XCTest
@testable import Weather

class WeatherServiceTests: XCTestCase {

    var service: WeatherService!
    let networkHandler = MockNetworkHandler()

    override func setUp() {
        service = WeatherService(networkHandler: networkHandler)
    }

    override func tearDown() {
        service = nil
    }
    
    func testRequestIsCalledIfDownloadWeather() {
        service.downloadWeather(cityName: "London") { (_, _) in}
        XCTAssertTrue(networkHandler.isCalled)
    }
    
    func testErrorIfHandleFailure() {
        let expeactError = NetworkError.invalidData
        networkHandler.nextError = expeactError
        
        var acutalError: NetworkError?

        service.downloadUVValue(latitude: "10", longitude: "10") { (_, error) in
            acutalError = error as? NetworkError
        }
        
        XCTAssert(expeactError == acutalError)
    }
    
    // Weather
    func testWeatherIfHandleSuccess() {
        let expeactModel = Weather(main: Main(temp: 285.81), name: "London", cod: 200)

        networkHandler.nextResult = expeactModel
        var acutalModel: Weather?

        service.downloadWeather(cityName: "London") { (weather, _) in
            acutalModel = weather
        }
        
        XCTAssert(acutalModel == expeactModel)
    }

    // UV    
    func testUVIfHandleSuccess() {
        let expeactModel = UV(value: 12)
        
        networkHandler.nextResult = expeactModel
        var acutalModel: UV?

        service.downloadUVValue(latitude: "10", longitude: "10") { (uv, _) in
            acutalModel = uv
        }
        
        XCTAssert(acutalModel == expeactModel)
    }
}
