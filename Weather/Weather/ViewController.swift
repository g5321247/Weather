//
//  ViewController.swift
//  Weather
//
//  Created by George Liu on 2019/5/7.
//  Copyright © 2019 George Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tfCityName: UITextField!
    
    @IBAction func tapTemperatureBtn(_ sender: UIButton) {
        guard let cityName = tfCityName.text else {
            #warning("Show Error")
            return
        }
        
        let vc = WeatherViewController(nibName: String(describing: WeatherViewController.self), bundle: nil)
        
        vc.inject(cityName: cityName, type: .currentWeather)
        show(vc, sender: nil)
    }
    
    @IBAction func tapUVValueBtn(_ sender: UIButton) {
        guard let cityName = tfCityName.text else {
            #warning("Show Error")
            return
        }
        
        let vc = WeatherViewController(nibName: String(describing: WeatherViewController.self), bundle: nil)
        
        vc.inject(cityName: cityName, type: .uvValue)
        show(vc, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

