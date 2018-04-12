//
//  WeatherDetail.swift
//  WeatherGift
//
//  Created by Estevan Feliz on 3/31/18.
//  Copyright © 2018 Feliz Studios. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherDetail: WeatherLocation {
    
    struct HourlyForecast{
        var hourlyTime: Double
        var hourlyTemperature: Double
        var hourlyPrecipProb: Double
        var hourlyIcon: String
    }
    
    struct DailyForecast {
        var dailyMaxTemp: Double
        var dailyMinTemp: Double
        var dailySummary: String
        var dailyDate: Double
        var dailyIcon: String
    }
    
    var currentTemp = "--"
    var daySummary = ""
    var currentIcon = ""
    var currentTime = 0.0
    var timeZone = ""
    
    var hourlyForecastArray = [HourlyForecast]()
    var dailyForcecastArray = [DailyForecast]()
    
    func getWeather(completed: @escaping () -> ()) {
        let weatherURL = urlBase + urlAPIKey + coordinates
        
        Alamofire.request(weatherURL).responseJSON { response in
            switch response.result {
            case . success(let value):
                let json = JSON(value)
                if let temperature = json["currently"]["temperature"].double {
                    let roundedTemp = String(format: "%3.f", temperature)
                    self.currentTemp = roundedTemp + "°"
                } else {
                    print("Could not return a temperature.")
                }
                if let summary = json["daily"]["summary"].string {
                    self.daySummary = summary
                } else {
                    print("could not return a summary.")
                }
                if let icon = json["currently"]["icon"].string {
                    self.currentIcon = icon
                } else {
                    print("could not return a summary.")
                }
                if let timezone = json["timezone"].string {
                    self.timeZone = timezone
                } else {
                    print("could not return a timezone.")
                }
                if let currTime = json["currently"]["time"].double {
                    self.currentTime = currTime
                } else {
                    print("could not return a time.")
                }
                
                let dailyDataArray = json["daily"]["data"]
                self.dailyForcecastArray = []
                let days = min(7, dailyDataArray.count-1)
                for day in 1...days {
                    let maxTemp = json["daily"]["data"][day]["temperatureHigh"].doubleValue
                    let minTemp = json["daily"]["data"][day]["temperatureLow"].doubleValue
                    let dateValue = json["daily"]["data"][day]["time"].doubleValue
                    let icon = json["daily"]["data"][day]["icon"].stringValue
                    let dailySummary = json["daily"]["data"][day]["summary"].stringValue
                    let newDailyForecast = DailyForecast(dailyMaxTemp: maxTemp, dailyMinTemp: minTemp, dailySummary: dailySummary, dailyDate: dateValue, dailyIcon: icon)
                    self.dailyForcecastArray.append(newDailyForecast)
                }
                
                let hourlyDataArray = json["hourly"]["data"]
                self.hourlyForecastArray = []
                let hours = min(24, hourlyDataArray.count-1)
                for hour in 1...hours {
                    let hourlyTime = json["hourly"]["data"][hour]["time"].doubleValue
                    let hourlyTemperature = json["hourly"]["data"][hour]["temperature"].doubleValue
                    let hourlyPrecipProb = json["hourly"]["data"][hour]["precipProbablility"].doubleValue
                    let hourlyIcon = json["hourly"]["data"][hour]["icon"].stringValue
                    let newHourlyForecast = HourlyForecast(hourlyTime: hourlyTime, hourlyTemperature: hourlyTemperature, hourlyPrecipProb: hourlyPrecipProb, hourlyIcon: hourlyIcon)
                    self.hourlyForecastArray.append(newHourlyForecast)
                }
            case .failure(let error):
                print(error)
            }
            completed()
        }
    }
}
