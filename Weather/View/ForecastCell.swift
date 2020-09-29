//
//  ForecastCell.swift
//  Weather
//
//  Created by Jonathan Tsistinas on 9/11/20.
//  Copyright © 2020 Jonathan Tsistinas. All rights reserved.
//

import UIKit

class ForecastCell: UICollectionViewCell {
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var forecastImage: UIImageView!
    
    func updateForecastViews(forecast: WeatherModel) {
//        time.text = "\(forecast.hourly[0])"
//        temperature.text = forecast.temperature
//        forecastImage.image = UIImage(named: forecast.forecastImage)
        time.text = "Some time here"
        temperature.text = "\(forecast.hourly[0])"
    }
    
}
