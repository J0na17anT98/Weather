//
//  DataService.swift
//  Weather
//
//  Created by Jonathan Tsistinas on 9/11/20.
//  Copyright © 2020 Jonathan Tsistinas. All rights reserved.
//

import Foundation

struct NetworkService {
    static let shared = NetworkService()
    
    let URL_BASE = "http://api.openweathermap.org/data/2.5/weather?"
    let LATITUDE = "lat="
    let LONGITUDE = "&lon="
    let APP_ID = "&appid="
    let API_KEY = "10d6bb5afb374912a2c7e74d5cf91353"
    
    let session = URLSession(configuration: .default)
    
    func getWeather(onSuccess: @escaping (Forecast, WeatherItems, Main) -> Void, onError: @escaping (String) -> Void) {
        let url = URL(string: "\(URL_BASE)\(LATITUDE)\(latitude!)\(LONGITUDE)\(longitude!)\(APP_ID)\(API_KEY)")!
        
        let task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                guard let data = data, let response = response as? HTTPURLResponse else {
                    onError("Invalid data or response")
                    return
                }
                do {
                    if response.statusCode == 200 {
                        //parse the succesfull result (Forecast)
                        let forecastItems = try JSONDecoder().decode(Forecast.self, from: data)
                        let weatherItems = try JSONDecoder().decode(WeatherItems.self, from: data)
                        let main = try JSONDecoder().decode(Main.self, from: data)
                        //handle Success
                        onSuccess(forecastItems, weatherItems, main)
                        
                    } else {
                        //show error to user
                        let err = try JSONDecoder().decode(APIError.self, from: data)
                        //handle error
                        onError(err.message)
                    }
                } catch {
                    onError(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
//   typealias DownloadComplete = () -> ()
//
//    let CURRENT_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude!)&lon=\(longitude!)&appid=0001911cebe16b8728c037499b068e0d"
//    let FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(latitude!)&lon=\(longitude!)&cnt=10&mode=json&appid=0001911cebe16b8728c037499b068e0d"
}
