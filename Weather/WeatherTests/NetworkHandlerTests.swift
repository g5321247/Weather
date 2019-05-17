//
//  ServiceTest.swift
//  WeatherTests
//
//  Created by George Liu on 2019/5/8.
//  Copyright © 2019 George Liu. All rights reserved.
//

import XCTest
@testable import Weather

class NetworkHandlerTests: XCTestCase {
    
    var networkHandler: NetworkHandler!
    let session = MockURLSession()
    
    override func setUp() {
        networkHandler = NetworkHandler(session: session)
    }
    
    override func tearDown() {
        networkHandler = nil
    }
    
    // Request
    func testRequestURL() {
        let url = URL(string: "www.google.com")!
        let request = URLRequest(url: url)
        
        networkHandler.sendRequest(request: request) { (_: Data?, _) in}
        
        XCTAssert(session.request!.url == url)
    }
    
    func testRequestMethod() {
        let url = URL(string: "www.google.com")!
        let request = URLRequest(url: url)
        
        networkHandler.sendRequest(request: request) { (_: Data?, _) in}

        XCTAssert(session.request!.httpMethod == APIMethod.get.rawValue)
    }
    
    func testRequestIsCalledIfSendRequest() {
        let url = URL(string: "www.google.com")!
        let request = URLRequest(url: url)
        
        networkHandler.sendRequest(request: request) { (_: Data?, _) in}
        
        XCTAssertTrue(session.nextDataTask.isCalled)
    }
    
    // Parse
    func testWeatherModelIfParseSuccess() {
        let data = getWeatherData()
        let expeactModel = getWeather()
        
        var acutalModel: Weather?
        
        networkHandler.parseResult(data: data) { model, _ in
            acutalModel = model
        }
        
        XCTAssert(acutalModel == expeactModel)
    }
    
    func testUVModelIfParseSuccess() {
        let data = getUVData()
        let expeactModel = getUV()
        
        var acutalModel: UV?
        
        networkHandler.parseResult(data: data) { model, _ in
            acutalModel = model
        }
        
        XCTAssert(acutalModel == expeactModel)
    }
    
    func testInvaildWeatherIfParseFailed() {
        let data = getUVData()
        
        var actualError: NetworkError?
        
        networkHandler.parseResult(data: data) { (model: Weather?, error) in
            actualError = error as? NetworkError
        }
        
        XCTAssert(actualError == NetworkError.jsonParsingFailure)
    }
    
    func testInvalidDataIfRequestFailed() {
        let url = URL(string: "www.google.com")!
        let request = URLRequest(url: url)

        session.nextResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.nextData = nil
        
        var actualError: NetworkError?
        
        networkHandler.sendRequest(request: request) { (_: Data?, error) in
            actualError = error as? NetworkError
        }
        
        XCTAssert(actualError! == NetworkError.invalidData)
    }
    
    // Error
    func testErrorIfLocalProblem() {
        let url = URL(string: "www.google.com")!
        let request = URLRequest(url: url)

        let expectedError = NSError(domain: "error", code: 0, userInfo: nil)
        session.nextError = expectedError
        
        networkHandler.sendRequest(request: request) { (_: Data?, error) in
            XCTAssert(error! as NSError == expectedError)
        }
    }
    
    // Response
    func testResponseLesserThan200() {
        let url = URL(string: "www.google.com")!
        let request = URLRequest(url: url)

        session.nextResponse = HTTPURLResponse(statusCode: 199)
        
        var actualError: NetworkError?
        
        networkHandler.sendRequest(request: request) { (_: Data?, error) in
            actualError = error as? NetworkError
        }
        XCTAssert(actualError! == NetworkError.responseUnsuccessful(statusCode: 199))
    }
    
    func testResponseGreaterThan300() {
        let url = URL(string: "www.google.com")!
        let request = URLRequest(url: url)
        
        session.nextResponse = HTTPURLResponse(statusCode: 300)
        var actualError: NetworkError?
        
        networkHandler.sendRequest(request: request) { (_: Data?, error) in
            actualError = error as? NetworkError
        }
        XCTAssert(actualError! == NetworkError.responseUnsuccessful(statusCode: 300))
    }
    
    func testRequestFail() {
        let url = URL(string: "www.google.com")!
        let request = URLRequest(url: url)
        
        session.nextResponse = nil
        var actualError: NetworkError?
        
        networkHandler.sendRequest(request: request) { (_: Data?, error) in
            actualError = error as? NetworkError
        }
        XCTAssert(actualError! == NetworkError.requestFailed)
    }
    
    // get URL
    func testURLIfURLIsInvalid() {
        let urlObject = MockURLRequestConvertible()
        
        do {
            _ = try networkHandler.getURL(model: urlObject)
        } catch {
            let actualError = error as? ConvertError
            XCTAssert(actualError == ConvertError.cannotConvertToURL)
        }
    }
    
    func testURLIfURLIsValid() {
        let urlObject = MockURLRequestConvertible()
        urlObject.domain = "https://api.openweathermap.org"
        urlObject.path = "/data/2.5/weather"
        
        let expectResult = URL(string: "https://api.openweathermap.org/data/2.5/weather")
        let result = try? networkHandler.getURL(model: urlObject)
        
        XCTAssert(expectResult == result)
    }
    
    // get URLRequest
    func testURLRequestIfURLIsInValid() {
        let urlObject = MockURLRequestConvertible()
        
        do {
            _ = try networkHandler.getRequest(model: urlObject)
        } catch {
            let actualError = error as? ConvertError
            XCTAssert(actualError == ConvertError.cannotConvertToURL)
        }
    }
    
    func testURLRequestIfURLIsValid() {
        let urlObject = MockURLRequestConvertible()
        urlObject.domain = "https://api.openweathermap.org"
        urlObject.path = "/data/2.5/weather"
        urlObject.parameters = ["q": "London"]
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=London")!
        let expectResult = URLRequest(url: url)
        let result = try? networkHandler.getRequest(model: urlObject)
        
        XCTAssert(expectResult == result)
    }
    
    // Download Process
    func testDownloadFailIfURLIsInvalid() {
        let urlObject = MockURLRequestConvertible()
        let expectError = ConvertError.cannotConvertToURL
        var actualError: ConvertError?

        networkHandler.download(model: urlObject) { (_: UV?, error) in
            actualError = error as? ConvertError
        }
        
        XCTAssert(expectError == actualError)
    }
    
    func testDownloadSuccessIfURLIsValid() {
        let urlObject = MockURLRequestConvertible()
        urlObject.domain = "https://api.openweathermap.org"
        urlObject.path = "/data/2.5/weather"
        urlObject.parameters = ["q": "London"]
        
        let url = URL(string: "www.google.com")!
        
        let expeactModel = getWeather()
        session.nextResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.nextData = getWeatherData()
        
        var acutalModel: Weather?

        networkHandler.download(model: urlObject) { (weather, _) in
            acutalModel = weather
        }

        XCTAssert(expeactModel == acutalModel)
    }
    
    func testDownloadFailIfRequestFail() {
        let urlObject = MockURLRequestConvertible()
        urlObject.domain = "https://api.openweathermap.org"
        urlObject.path = "/data/2.5/weather"
        urlObject.parameters = ["q": "London"]
        
        let expectError = NetworkError.requestFailed
        var actualError: NetworkError?
        session.nextResponse = nil
        
        networkHandler.download(model: urlObject) { (_: UV?, error) in
            actualError = error as? NetworkError
        }
        
        XCTAssert(expectError == actualError)
    }
}
