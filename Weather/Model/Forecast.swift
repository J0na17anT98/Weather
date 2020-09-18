//
//  forecastCell.swift
//  Weather
//
//  Created by Jonathan Tsistinas on 9/11/20.
//  Copyright © 2020 Jonathan Tsistinas. All rights reserved.
//

import Foundation

struct Forecast: Codable {
    let name: String
}

struct WeatherItems: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
}
