//
//  Gecoder.swift
//  Weather
//
//  Created by George Liu on 2019/5/18.
//  Copyright © 2019 George Liu. All rights reserved.
//

import CoreLocation

protocol CLGeocoderProtocol {
    typealias LocationHadler = (LocationString?, Error?) -> Void
    typealias LocationString = (latitude: String, longitude: String)
    func getLatitudeAndLongitudeString(_ addressString: String, completionHandler: @escaping LocationHadler)
}

extension CLGeocoder: CLGeocoderProtocol {
    
    func getLatitudeAndLongitudeString(_ addressString: String, completionHandler: @escaping LocationHadler) {
        getCoordinateFrom(address: addressString) { [weak self] (location, error) in
            guard let location = location else {
                if let error = error { completionHandler(nil, error) }
                return
            }
            
            let locationStr: LocationString? = self?.transformLocation(location: location)
            completionHandler(locationStr, nil)
        }
    }
    
    func transformLocation(location: CLLocationCoordinate2D) -> (latitude: String, longitude: String) {
        let latitude = String(format: "%.2f", location.latitude)
        let longitude = String(format: "%.2f", location.longitude)
        
        return (latitude: latitude, longitude: longitude)
    }
    
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        self.geocodeAddressString(address) {
            completion($0?.first?.location?.coordinate, $1)
        }
    }
}

class MockCLGeocoder: CLGeocoderProtocol {
    
    var nextLocationString: LocationString?
    var nextError: Error?
    private(set) var addressString: String?
    
    func getLatitudeAndLongitudeString(_ addressString: String, completionHandler: @escaping LocationHadler) {
        self.addressString = addressString
        completionHandler(nextLocationString, nextError)
    }
}
