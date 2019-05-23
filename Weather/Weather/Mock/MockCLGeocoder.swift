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
    private(set) var addressString: String?
    
    func getCoordinateStrFrom(_ addressString: String, completionHandler: @escaping LocationHadler) {
        self.addressString = addressString
        completionHandler(nextLocationString, nextError)
    }
}
