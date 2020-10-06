//
//  ViewController.swift
//  Weather
//
//  Created by ---- ---- on 9/11/20.
//  Copyright © 2020 ---- ----. All rights reserved.
//

import UIKit
import CoreLocation

//Public Variables
var longitude: Double?
var latitude: Double?

class WeatherVC: UIViewController, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

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
    let weather = CurrentWeatherNetworkService()
    
    let geoCoder = CLGeocoder()
    
    //MARK: - Collection View Cell Identifier
    let todaysCellReuseIdentifier = "todaysWeatherCell"
    
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
    
    //MARK: - Get Forecast
    func getForecast() {
        CurrentWeatherNetworkService.shared.getCurrentWeather(onSuccess: { (weather) in
            
            if "Mist" == weather.current.weather[0].main {
                self.currentWeatherImage.image = UIImage(systemName: "cloud.fog.fill")
            } else if "Haze" == weather.current.weather[0].main {
                self.currentWeatherImage.image = UIImage(systemName: "sun.haze.fill")
            } else if "Smoke" == weather.current.weather[0].main {
                self.currentWeatherImage.image = UIImage(systemName: "smoke.fill")
            } else if "Clouds" == weather.current.weather[0].main {
                self.currentWeatherImage.image = UIImage(systemName: "cloud.fill")
            } else if "Clear" == weather.current.weather[0].main {
                self.currentWeatherImage.image = UIImage(systemName: "sun.max.fill")
            } else if "Rain" == weather.current.weather[0].main {
                self.currentWeatherImage.image = UIImage(systemName: "cloud.heavyrain.fill")
            } else if "Snow" == weather.current.weather[0].main {
                self.currentWeatherImage.image = UIImage(systemName: "cloud.snow.fill")
            } else if "Fog" == weather.current.weather[0].main {
                self.currentWeatherImage.image = UIImage(systemName: "cloud.fog.fill")
            } else if "Thunderstorm" == weather.current.weather[0].main {
                self.currentWeatherImage.image = UIImage(systemName: "cloud.bolt.rain.fill")
            } else if "Drizzle" == weather.current.weather[0].main {
                self.currentWeatherImage.image = UIImage(systemName: "cloud.sun.rain.fill")
            }
            
            print(weather) //Print this to show JSON
//            self.currentLocationLabel.text = weather.name
            self.currentWeatherLabel.text = weather.current.weather[0].main
            
//            self.currentTemperature.text = "\(Int(floor(weather.main.temp * 9/5 - 459.67)))°F"
            self.currentTemperature.text = "\(Int(floor(weather.current.temp * 9/5 - 459.67)))°F"
            self.weatherLow.text = "H:\(Int(floor(weather.daily[0].temp.min * 9/5 - 459.67)))°F"
            self.weatherHigh.text = "H:\(Int(floor(weather.daily[0].temp.max * 9/5 - 459.67)))°F"

            
        }) { (errorMessage) in
            debugPrint(errorMessage)
        }
    }
    //MARK: - LOCATION MANAGER
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
//            print("\(locManager.location!.coordinate.longitude) & \(locManager.location!.coordinate.latitude)")
            longitude = locManager.location!.coordinate.longitude
            latitude = locManager.location!.coordinate.latitude
            print("\(longitude!) & \(latitude!)")
            getForecast()
            showLocationName()
        }
    }

    func locationManager(_ locManager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func showLocationName() {
        let location = CLLocation(latitude: latitude ?? 0, longitude:  longitude ?? 0)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in

            placemarks?.forEach { (placemark) in

                if let city = placemark.locality {
                    print(city)
                    self.currentLocationLabel.text = city
                }
            }
        })
    }
    
    //MARK: - Collection View Protocols
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: todaysCellReuseIdentifier, for: indexPath) as! ForecastCell
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.item)!")
    }
    
}
