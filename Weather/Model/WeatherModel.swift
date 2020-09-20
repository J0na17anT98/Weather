//
//  forecastCell.swift
//  Weather
//
//  Created by Jonathan Tsistinas on 9/11/20.
//  Copyright © 2020 Jonathan Tsistinas. All rights reserved.
//

import Foundation

struct WeatherModel: Codable {
    let weather: [Weather]
    let name: String?
    let main: Main
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
}

struct Main: Codable {
    let temp: Double
    let temp_min: Float
    let temp_max: Float
}
