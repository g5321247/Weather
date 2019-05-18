//
//  WeatherViewController.swift
//  Weather
//
//  Created by George Liu on 2019/5/7.
//  Copyright © 2019 George Liu. All rights reserved.
//

import UIKit

enum WeatherType {
    case currentWeather
    case uvValue
}

class WeatherViewController: UIViewController {

    @IBOutlet weak var llCityName: UILabel!
    @IBOutlet weak var llTemperature: UILabel!
    
    private var viewModel: WeatherViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        viewModel.inputs.checkWeatherCondition()
    }

    func inject(cityName: String, type: WeatherType) {
        let service = WeatherService()
        
        viewModel = WeatherViewModel(service: service, cityName: cityName, type: type)
    }
    
    private func bindViewModel() {
        var outputs = viewModel.outputs
        
        outputs.error = { [weak self] (error) in
            self?.llCityName.text = "錯誤"
            self?.llTemperature.text = error.localizedDescription
        }
        
        outputs.weather = { [weak self] (weather) in
            self?.llCityName.text = "城市：" + weather.name
            self?.llTemperature.text = "溫度：" + String(weather.main.temp)
        }
        
        outputs.uvValue = { [weak self] (uv) in
            self?.llCityName.text = "UV 指數：" + String(uv.value)
            self?.llTemperature.text = ""
        }
    }
}
