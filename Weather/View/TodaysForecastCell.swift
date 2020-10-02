//
//  ForecastCell.swift
//  Weather
//
//  Created by Jonathan Tsistinas on 9/11/20.
//  Copyright © 2020 Jonathan Tsistinas. All rights reserved.
//

import UIKit

class TodaysForecastCell: UICollectionViewCell {
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var forecastImage: UIImageView!
    
    func updateTodaysForecastViews(todaysForecast: WeatherModel) {
//        time.text = "\(forecast.hourly[0])"
//        temperature.text = forecast.temperature
//        forecastImage.image = UIImage(named: forecast.forecastImage)
        time.text = "\(todaysForecast.hourly.description)" //change this
        temperature.text = "\(todaysForecast.hourly[0].temp)"
    }
    
}
