//
//  ServiceTest.swift
//  WeatherTests
//
//  Created by George Liu on 2019/5/8.
//  Copyright © 2019 George Liu. All rights reserved.
//

import XCTest
@testable import Weather

class WebRequestTests: XCTestCase {
    
    var webRequest: WebRequest!
    let session = MockURLSession()
    
    override func setUp() {
        webRequest = WebRequest(session: session)
    }
    
    override func tearDown() {
        webRequest = nil
    }
    
    func testRequestURL() {
        let url = URL(string: "www.google.com")!
        let request = URLRequest(url: url)
        
        webRequest.sendRequest(request: request) { (_: Data?, _) in}
        
        XCTAssert(session.request!.url == url)
    }
    
    func testRequestMethod() {
        let url = URL(string: "www.google.com")!
        let request = URLRequest(url: url)
        
        webRequest.sendRequest(request: request) { (_: Data?, _) in}

        XCTAssert(session.request!.httpMethod == APIMethod.get.rawValue)
    }
    
    func testRequestIsCalledIfSendRequest() {
        let url = URL(string: "www.google.com")!
        let request = URLRequest(url: url)
        
        webRequest.sendRequest(request: request) { (_: Data?, _) in}
        
        XCTAssertTrue(session.nextDataTask.isCalled)
    }
    
    // Parse
    func testVaildModelIfParseSuccess() {
        let url = URL(string: "www.google.com")!
        let request = URLRequest(url: url)
        
        let expeactModel = Weather(main: Main(temp: 285.81), name: "London", cod: 200)
        session.nextResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.nextData = getWeatherData()
        
        var acutalModel: Weather?
        
        webRequest.sendRequest(request: request) { model, _ in
            acutalModel = model
        }
        
        XCTAssert(acutalModel == expeactModel)
    }
    
    func testInvaildModelIfParseFailed() {
        let url = URL(string: "www.google.com")!
        let request = URLRequest(url: url)
        
        session.nextResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.nextData = getWeatherData()
        
        var actualError: NetworkError?
        
        webRequest.sendRequest(request: request) { (model: UV?, error) in
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
        
        webRequest.sendRequest(request: request) { (_: Data?, error) in
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
        
        webRequest.sendRequest(request: request) { (_: Data?, error) in
            XCTAssert(error! as NSError == expectedError)
        }
    }
    
    // Response
    func testResponseLesserThan200() {
        let url = URL(string: "www.google.com")!
        let request = URLRequest(url: url)

        session.nextResponse = HTTPURLResponse(statusCode: 199)
        
        var actualError: NetworkError?
        
        webRequest.sendRequest(request: request) { (_: Data?, error) in
            actualError = error as? NetworkError
        }
        XCTAssert(actualError! == NetworkError.responseUnsuccessful(statusCode: 199))
    }
    
    func testResponseGreaterThan300() {
        let url = URL(string: "www.google.com")!
        let request = URLRequest(url: url)
        
        session.nextResponse = HTTPURLResponse(statusCode: 300)
        var actualError: NetworkError?
        
        webRequest.sendRequest(request: request) { (_: Data?, error) in
            actualError = error as? NetworkError
        }
        XCTAssert(actualError! == NetworkError.responseUnsuccessful(statusCode: 300))
    }
    
    func testRequestFail() {
        let url = URL(string: "www.google.com")!
        let request = URLRequest(url: url)
        
        session.nextResponse = nil
        var actualError: NetworkError?
        
        webRequest.sendRequest(request: request) { (_: Data?, error) in
            actualError = error as? NetworkError
        }
        XCTAssert(actualError! == NetworkError.requestFailed)
    }
    
}
