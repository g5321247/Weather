//
//  WeatherViewController.swift
//  Weather
//
//  Created by George Liu on 2019/5/7.
//  Copyright © 2019 George Liu. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var llCityName: UILabel!
    @IBOutlet weak var llTemperature: UILabel!
    
    private var viewModel: WeatherViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        viewModel.inputs.searchCityWeather()
    }

    func inject(cityName: String) {
        let service = WeatherService()
        viewModel = WeatherViewModel(service: service, cityName: cityName)
    }
    
    private func bindViewModel() {
        var outputs = viewModel.outputs
        
        outputs.error = { [weak self] (error) in
            #warning("Error handling")
        }
        
        outputs.weather = { [weak self] (weather) in
            self?.llCityName.text = "城市：" + weather.name
            self?.llTemperature.text = "溫度：" + String(weather.main.temp)
        }
    }
}
