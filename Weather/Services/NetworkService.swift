//
//  DataService.swift
//  Weather
//
//  Created by Jonathan Tsistinas on 9/11/20.
//  Copyright © 2020 Jonathan Tsistinas. All rights reserved.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    let URL_BASE = "https://api.openweathermap.org/data/2.5/onecall?" //"http://api.openweathermap.org/data/2.5/weather?"
    let LATITUDE = "lat="
    let LONGITUDE = "&lon="
    let EXCLUDE = "&exclude=alerts,minutely"
    let APP_ID = "&appid="
    let API_KEY = "10d6bb5afb374912a2c7e74d5cf91353"
    
    let session = URLSession(configuration: .default)
    
    func getWeather(onSuccess: @escaping (WeatherModel) -> Void, onError: @escaping (String) -> Void) {
        let API_URL = URL(string: "\(URL_BASE)\(LATITUDE)\(latitude!)\(LONGITUDE)\(longitude!)\(EXCLUDE)\(APP_ID)\(API_KEY)")!
        
        let task = session.dataTask(with: API_URL) { (data, response, error) in
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
                        let forecast = try JSONDecoder().decode(WeatherModel.self, from: data)
                        onSuccess(forecast)
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
}
