//
//  MockCLGeocoder.swift
//  Weather
//
//  Created by george.liu on 2019/5/23.
//  Copyright © 2019 George Liu. All rights reserved.
//

import Foundation

class MockCLGeocoder: CLGeocoderProtocol {
    
    var nextLocationString: LocationString?
    var nextError: Error?
    private(set) var cityName: String?
    
    func getCoordinateStrFrom(_ addressString: String, completionHandler: @escaping LocationHadler) {
        cityName = addressString
        completionHandler(nextLocationString, nextError)
    }
}
