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
    @IBOutlet weak var segmentedControl: UISegmentedControl! //Not Complete, will change based on data from API
    
    let date = Date()
    let locManager = CLLocationManager()
    
    var forecast: Forecast!
    var weatherItems: WeatherItems!
    var main: Main!
//    var forecast: Forecast!
//    var forecasts = [Forecast]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradient()
        displayCurrentdate()
        
        //Request Location Access
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
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
        NetworkService.shared.getWeather(onSuccess: { (forecast, weatherItems, main) in
            self.forecast = forecast //call items directly in Forecast struct
            self.weatherItems = weatherItems
            self.main = main
            
            print(forecast)
            self.currentLocationLabel.text = forecast.name
            self.currentWeatherLabel.text = weatherItems.description
            self.currentTemperature.text = "\(main.temp)"
            self.currentWeatherImage.image = UIImage(named: "")
            
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
