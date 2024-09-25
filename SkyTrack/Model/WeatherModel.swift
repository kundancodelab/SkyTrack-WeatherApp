//
//  SkyTrackerModel.swift
//  SkyTracker
//
//  Created by Kundan ios dev  on 03/07/24.
//

import Foundation

struct WeatherModel {
    var conditionId:Int
    var cityName:String
    var description:String
    var temprature:Double
    var weatherIcon:String
    var windSpeed:String
    var humdity:String
    var tempratureString:String {
        return String(format: "%.1f", temprature)
    }
    
    var conditionString:String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        
        default:
            return "cloud"
        }
    }
}
