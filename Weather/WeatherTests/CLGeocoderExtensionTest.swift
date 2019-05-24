//
//  CLGeocoderExtensionTest.swift
//  WeatherTests
//
//  Created by george.liu on 2019/5/23.
//  Copyright © 2019 George Liu. All rights reserved.
//

import XCTest
import CoreLocation

@testable import Weather

class CLGeocoderExtensionTest: XCTestCase {

    var geocoder: CLGeocoder!
    
    override func setUp() {
        geocoder = CLGeocoder()
    }

    override func tearDown() {
        geocoder = nil
        
    }

    // CLLocation
    func testValidCoordinateIfValidAddress() {
        let city = "London"
        let expect = expectation(description: "get coordinate")

        let expectLocation = CLLocationCoordinate2D(latitude: 51.5001524, longitude: -0.1262362)
        
        geocoder.getCoordinateFrom(address: city) { (locations, _) in
            XCTAssert(expectLocation.latitude == locations?.latitude, "latitude incorrect")
            XCTAssert(expectLocation.longitude == locations?.longitude, "longitude incorrect")
            
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testValidCoordinateIfValidAddressFirstLetterIsLowerCase() {
        let city = "london"
        let expect = expectation(description: "get coordinate")
        
        let expectLocation = CLLocationCoordinate2D(latitude: 51.5001524, longitude: -0.1262362)
        
        geocoder.getCoordinateFrom(address: city) { (locations, _) in
            XCTAssert(expectLocation.latitude == locations?.latitude, "latitude incorrect")
            XCTAssert(expectLocation.longitude == locations?.longitude, "longitude incorrect")
            
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    
    func testNilCoordinatefInvalidAddress() {
        let city = "Yo"
        let expect = expectation(description: "locations should be nil")
        
        geocoder.getCoordinateFrom(address: city) { (locations, _) in
            XCTAssert(locations == nil , "locations get unexpected value")
            
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testErrorfInvalidAddress() {
        let city = "Yo"
        let expect = expectation(description: "get error")
        
        geocoder.getCoordinateFrom(address: city) { (_, error) in
            XCTAssert(error != nil , "can't get error")
            
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    // Transform CLLocation to String
    func testLocationString() {
        let location = CLLocationCoordinate2D(latitude: 51.5001524, longitude: -0.1262362)
        let expectLocationStr = ("51.50", "-0.13")
        
        let locationStr = geocoder.transformLocation(location: location)
        
        XCTAssert(expectLocationStr == locationStr, "locationString incorrect")
    }
    
    // Get Address Latitude & Longitude String
    func testValidCoordinateStringIfValidAddress() {
        let city = "London"
        let expect = expectation(description: "get coordinate String")
        
        let expectLocationStr = ("51.50", "-0.13")

        geocoder.getCoordinateStrFrom(city) { (locationStr, _) in
            XCTAssert(expectLocationStr == locationStr!, "locationString incorrect")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testInvalidCoordinateStringIfInvalidAddress() {
        let city = "Yo"
        let expect = expectation(description: "locationsStr should be nil")
        
        geocoder.getCoordinateStrFrom(city) { (locationStr, _) in
            XCTAssert(locationStr == nil, "locations get unexpected value")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testErrorCoordinateStringIfInvalidAddress() {
        let city = "Yo"
        let expect = expectation(description: "locationsStr should be nil")
        
        geocoder.getCoordinateStrFrom(city) { (_, error) in
            
            let actualError = error as? ConvertError

            XCTAssert(actualError == ConvertError.address, "error incorrect")
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

}
