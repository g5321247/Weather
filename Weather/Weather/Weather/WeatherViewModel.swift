//
//  ViewModel.swift
//  Weather
//
//  Created by George Liu on 2019/5/7.
//  Copyright © 2019 George Liu. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherViewModelInputs {
    func checkWeatherCondition()
}

protocol WeatherViewModelOutputs {
    var weather: ((Weather) -> Void)? { get set }
    var uvValue: ((UV) -> Void)? { get set }
    var error: ((Error) -> Void)? { get set }
}

class WeatherViewModel: WeatherViewModelInputs, WeatherViewModelOutputs {
    
    var inputs: WeatherViewModelInputs { return self }
    var outputs: WeatherViewModelOutputs { return self }
    
    // MARK: - ViewModelOutputParameter
    var weather: ((Weather) -> Void)?
    var error: ((Error) -> Void)?
    var uvValue: ((UV) -> Void)?

    // MARK: - Private Varible
    private let service: WeatherServiceSpec
    private let geocoder: CLGeocoder
    private let cityName: String
    private var type: WeatherType = .currentWeather
    
    // MARK: - Dependency Injection
    init(service: WeatherServiceSpec, cityName: String, type: WeatherType, geocoder: CLGeocoder = CLGeocoder()) {
        self.service = service
        self.geocoder = geocoder
        self.cityName = cityName
        self.type = type
    }

    // MARK: - ViewModelInputs
    func checkWeatherCondition() {
        switch type {
        case .currentWeather:
            downloadCurrentWeather()
        case .uvValue:
            downloadUV()
        }
    }
}

extension WeatherViewModel {
    
    func downloadCurrentWeather() {
        service.downloadWeather(cityName: cityName) { [weak self] (weather, error) in
            
            DispatchQueue.main.async {
                guard let weather = weather else {
                    self?.error?(error!)
                    return
                }
                self?.weather?(weather)
            }
        }
    }
    
    func downloadUV() {
        getCoordinateFrom(address: cityName) { [weak self] coordinate, error in
            
            guard let coordinate = coordinate, error == nil else {
                self?.error?(error!)
                return
            }
            
            let latitude = String(format: "%.2f", coordinate.latitude)
            let longitude = String(format: "%.2f", coordinate.longitude)
            
            self?.service.downloadUVValue(latitude: latitude, longitude: longitude, completion: { (uv, error) in
                
                DispatchQueue.main.async {
                    guard let uv = uv else {
                        self?.error?(error!)
                        return
                    }
                    self?.uvValue?(uv)
                }
            })
        }
    }
    
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        geocoder.geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }
}
