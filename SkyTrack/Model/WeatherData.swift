//
//  WeatherData.swift
//  SkyTracker
//
//  Created by Kundan ios dev  on 03/07/24.
//

import Foundation


import Foundation

struct WeatherData:Decodable {
    let name:String
    let main:Main
    let weather:[Weather]
    let wind:Wind
}

struct Main:Decodable{
    let temp:Double
    let humidity:Double
}

struct Weather:Decodable{
    let description:String
    let id:Int
    let icon:String
    
}

struct Wind:Decodable{
    let speed:Double
}


