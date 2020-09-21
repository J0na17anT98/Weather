//
//  ViewController.swift
//  Weather
//
//  Created by Jonathan Tsistinas on 9/11/20.
//  Copyright © 2020 Jonathan Tsistinas. All rights reserved.
//

import UIKit
import CoreLocation

//Public Variables
var longitude: Double?
var latitude: Double?

class WeatherVC: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var backgroundGradientView: UIView! //Complete
    @IBOutlet weak var currentDate: UILabel! //Complete
    @IBOutlet weak var currentDay: UILabel! //Complete
    @IBOutlet weak var currentLocationLabel: UILabel! //Not Complete, comes from API
    @IBOutlet weak var currentWeatherLabel: UILabel! //Not Complete, comes from API
    @IBOutlet weak var currentTemperature: UILabel! //Not Complete, comes from API
    @IBOutlet weak var currentWeatherImage: UIImageView! //Not Complete, will change based on data from API
    @IBOutlet weak var weatherHigh: UILabel!
    @IBOutlet weak var weatherLow: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl! //Not Complete, will change based on data from API
    
    let date = Date()
    let locManager = CLLocationManager()
    let weather = WeatherNetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradient()
        displayCurrentdate()
        
        //Request Location Access
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
    }
    
    //MARK: - CURRENT DATE
    func displayCurrentdate() {
        //current month & day
        let components = date.get(.day, .month, .year)
        if let day = components.day, let month = components.month {
            currentDate.text = "\(DateFormatter().monthSymbols[month-1].capitalized) \(day)"
        }
        
        //current day's name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfTheWeekString = dateFormatter.string(from: date)
        currentDay.text = "\(dayOfTheWeekString)"
    }
    
    //MARK: - BACKGROUND GRADIENT
    func gradient() {
        //gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0, green: 0.5725490196, blue: 0.2705882353, alpha: 1).cgColor, UIColor(red: 252/255, green: 238/255, blue: 33/255, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        backgroundGradientView.layer.insertSublayer(gradientLayer, at: 0)
        
        //segmented control
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
    }
    
    //MARK: - LOCATION MANAGER
    func getForecast() {
        WeatherNetworkService.shared.getWeather(onSuccess: { (weather) in
            
            if "Mist" == weather.weather[0].main {
                self.currentWeatherImage.image = UIImage(systemName: "cloud.fog.fill")
            } else if "Haze" == weather.weather[0].main {
                self.currentWeatherImage.image = UIImage(systemName: "sun.haze.fill")
            } else if "Smoke" == weather.weather[0].main {
                self.currentWeatherImage.image = UIImage(systemName: "smoke.fill")
            } else if "Clouds" == weather.weather[0].main {
                self.currentWeatherImage.image = UIImage(systemName: "cloud.fill")
            } else if "Clear" == weather.weather[0].main {
                self.currentWeatherImage.image = UIImage(systemName: "sun.max.fill")
            } else if "Rain" == weather.weather[0].main {
                self.currentWeatherImage.image = UIImage(systemName: "cloud.heavyrain.fill")
            } else if "Snow" == weather.weather[0].main {
                self.currentWeatherImage.image = UIImage(systemName: "cloud.snow.fill")
            } else if "Fog" == weather.weather[0].main {
                self.currentWeatherImage.image = UIImage(systemName: "cloud.fog.fill")
            } else if "Thunderstorm" == weather.weather[0].main {
                self.currentWeatherImage.image = UIImage(systemName: "cloud.bolt.rain.fill")
            } else if "Drizzle" == weather.weather[0].main {
                self.currentWeatherImage.image = UIImage(systemName: "cloud.sun.rain.fill")
            }
            
            print(weather)
            self.currentLocationLabel.text = weather.name
            self.currentWeatherLabel.text = weather.weather[0].main
            
            self.currentTemperature.text = "\(Int(floor(weather.main.temp * 9/5 - 459.67)))°F"
            self.weatherHigh.text = "H:\(Int(floor(weather.main.temp_max * 9/5 - 459.67)))°"
            self.weatherLow.text = "L:\(Int(floor(weather.main.temp_min * 9/5 - 459.67)))°"
            
        }) { (errorMessage) in
            debugPrint(errorMessage)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
//            print("\(locManager.location!.coordinate.longitude) & \(locManager.location!.coordinate.latitude)")
            longitude = locManager.location!.coordinate.longitude
            latitude = locManager.location!.coordinate.latitude
            print("\(longitude!) & \(latitude!)")
            getForecast()
        }
    }

    func locationManager(_ locManager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
