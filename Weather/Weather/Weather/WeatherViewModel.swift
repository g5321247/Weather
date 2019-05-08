//
//  ViewModel.swift
//  Weather
//
//  Created by George Liu on 2019/5/7.
//  Copyright © 2019 George Liu. All rights reserved.
//

import Foundation

protocol WeatherViewModelInputs {
    func searchCityWeather()
}

protocol WeatherViewModelOutputs {
    var weather: ((Weather) -> Void)? { get set }
    var error: ((Error) -> Void)? { get set }
}

class WeatherViewModel: WeatherViewModelInputs, WeatherViewModelOutputs {
    
    var inputs: WeatherViewModelInputs { return self }
    var outputs: WeatherViewModelOutputs { return self }
    
    // MARK: - ViewModelOutputParameter
    var weather: ((Weather) -> Void)?
    var error: ((Error) -> Void)?
    
    // MARK: - Private Varible
    private let service: WeatherServiceSpec
    private let cityName: String
    
    // MARK: - Dependency Injection
    init(service: WeatherServiceSpec, cityName: String) {
        self.service = service
        self.cityName = cityName
    }

    // MARK: - ViewModelInputs
    func searchCityWeather() {
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
}
