//
//  ForecastCell.swift
//  Weather
//
//  Created by Jonathan Tsistinas on 9/11/20.
//  Copyright © 2020 Jonathan Tsistinas. All rights reserved.
//

import UIKit

class WeatherCell: UICollectionViewCell {
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var forecastImage: UIImageView!
    
    func configureCell(weather: WeatherModel) {
        self.time.text = "\(weather.hourly[0])"
        self.temperature.text = "show weather here"
    }
    
    func updateForecastViews(weather: WeatherModel) {
//        time.text = "\(forecast.hourly[0])"
//        temperature.text = forecast.temperature
//        forecastImage.image = UIImage(named: forecast.forecastImage)
        time.text = "Some time here"
        temperature.text = "\(weather.hourly[0])"
    }
    
}
