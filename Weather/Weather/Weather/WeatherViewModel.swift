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
    func searchCityWeather()
}

protocol WeatherViewModelOutputs {
    var weather: ((Weather) -> Void)? { get set }
    var pollution: ((Datum) -> Void)? { get set }
    var error: ((Error) -> Void)? { get set }
}

class WeatherViewModel: WeatherViewModelInputs, WeatherViewModelOutputs {
    
    var inputs: WeatherViewModelInputs { return self }
    var outputs: WeatherViewModelOutputs { return self }
    
    // MARK: - ViewModelOutputParameter
    var weather: ((Weather) -> Void)?
    var error: ((Error) -> Void)?
    var pollution: ((Datum) -> Void)?

    // MARK: - Private Varible
    private let service: WeatherServiceSpec
    private let cityName: String
    private var type: WeatherType = .currentWeather
    
    // MARK: - Dependency Injection
    init(service: WeatherServiceSpec, cityName: String, type: WeatherType) {
        self.service = service
        self.cityName = cityName
        self.type = type
    }

    // MARK: - ViewModelInputs
    func searchCityWeather() {
        switch type {
        case .currentWeather:
            downloadCurrentWeather()
        case .airPollution:
            downloadAirPollution()
        }
    }
    
    private func downloadCurrentWeather() {
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
    
    private func downloadAirPollution() {
        getCoordinateFrom(address: cityName) { [weak self] coordinate, error in
            guard let coordinate = coordinate, error == nil else { return }
            
            let latitude = String(format: "%.2f", coordinate.latitude)
            let longitude = String(format: "%.2f", coordinate.longitude)
            
            self?.service.downloadPollution(latitude: latitude, longitude: longitude, completion: { (pollution, error) in
                
                DispatchQueue.main.async {
                    guard let pollution = pollution, let data = pollution.data.first else {
                        self?.error?(error!)
                        return
                    }
                    self?.pollution?(data)
                }
            })
        }
    }
    
    private func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }
}
