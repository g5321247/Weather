//
//  Gecoder.swift
//  Weather
//
//  Created by George Liu on 2019/5/18.
//  Copyright © 2019 George Liu. All rights reserved.
//

import CoreLocation


protocol CLGeocoderProtocol {
    func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler)
}

extension CLGeocoder: CLGeocoderProtocol {}
