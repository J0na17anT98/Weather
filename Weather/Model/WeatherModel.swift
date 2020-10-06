//
//  forecastCell.swift
//  Weather
//
//  Created by Jonathan Tsistinas on 9/11/20.
//  Copyright © 2020 Jonathan Tsistinas. All rights reserved.
//

import Foundation
//MARK: - Old Weather Model
//struct OldWeatherModel: Codable {
//    let weather: [Weather]
//    let name: String?
//    let main: Main
//}
//
//struct Weather: Codable {
//    let id: Int
//    let main: String
//    let description: String
//}
//
//struct Main: Codable {
//    let temp: Double
//    let temp_min: Float
//    let temp_max: Float
//}

//MARK: - Weather Model
struct WeatherModel: Codable {
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
//    let name: String?
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
}

struct Current: Codable {
    let sunrise: Double
    let sunset: Double
    let temp: Double
    let feels_like: Double
    let weather: [Weather] //Using Weather from Old Weather Model
}

struct Hourly: Codable {
    //returns 48hrs worth of hourly forecast. At most, will be using 5hrs.
    let temp: Double
//    let feels_like: Double
    let weather: [Weather] //Using Weather from Old Weather Model
}

struct Daily: Codable {
    let sunrise: Double
    let sunset: Double
    let temp: Temp
    let weather: [Weather] //Using Weather from Old Weather Model
}

struct Temp: Codable {
    let min: Float
    let max: Float
}
