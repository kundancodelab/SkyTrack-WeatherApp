//
//  WheatherManager.swift
//  Clima
//
//  Created by Kundan ios dev  on 28/06/24.
//  Copyright © 2024 App Brewery. All rights reserved.
// 

import UIKit
import CoreLocation


protocol WeatherManagerDelegate{
    func  didupdateWeather(weather:WeatherModel)
}
struct WeatherManager {
   
    var weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1e52853ff4a4c1624b16620db1ed0763&units=metric"
    var delegate:WeatherManagerDelegate?
    var sencondDelegate:showAlertViewDelagate?
    func fetchWeather(cityname:String){
        let urlString = "\(weatherURL)&q=\(cityname)"
        
       performRequest(urlString: urlString)
        
    }
    
    
    func fetchWeather(latitute:CLLocationDegrees, longitute:CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitute)&lon=\(longitute)"
        
       performRequest(urlString: urlString)
        
    }

    // We have written here networking code.
    
    func performRequest(urlString: String) {
        // 1 Create a URL
        if let url = URL(string: urlString) {
            // 2 Create a URL Session and a task
            let session = URLSession(configuration: .default)
            
            // 3 Give a session task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    sencondDelegate?.showLocationServicesDeniedAlert(tilte: "No inernet connection", messege: "Oops Please check internet connection and try again.. ")
                }
                
                if let safeData = data {
                    if let weather =  self.parseJSON(weatherData: safeData) {
                        DispatchQueue.main.async {
                           //let vc = WeatherEntryViewController()
                           // vc.weatherdata = weather
                           // print(vc.weatherdata)
                          //  return
                        }
                            
                        self.delegate?.didupdateWeather(weather: weather)
                        
                    }
                }
            }
            task.resume()
        }
    }

    func parseJSON(weatherData: Data) -> WeatherModel? {
        // Your JSON parsing code here
        // 1 Create an object Decoder clas.
        let decoder = JSONDecoder()
        // Call the decode method to extract the data
        do {
            let decodedData =  try decoder.decode(WeatherData.self, from: weatherData)
            
           
            let windspeed = decodedData.wind.speed
            let humidity = decodedData.main.humidity
            let conditionId = decodedData.weather[0].id
            let description = decodedData.weather[0].description
            let cityname = decodedData.name
            let temprature = decodedData.main.temp
            let icon = decodedData.weather[0].icon
            
            let weather = WeatherModel(conditionId: conditionId, cityName: cityname, description: description, temprature: temprature, weatherIcon: icon , windSpeed: String(windspeed), humdity: String(humidity))
            
            return  weather

        }catch{
            DispatchQueue.main.async {
                
                
                sencondDelegate?.showLocationServicesDeniedAlert(tilte: "City not found", messege: "Please enter valid city name or location ")
                
                print("unwanted error")
                print("error is here not elsewhere")
            }
            return nil
        }
        
    }
    
    
    // https://openweathermap.org/img/wn/10d@2x.png
    
    
    func setWeatherIcon( _ imageIcon:String, _ imageView:UIImageView)  {
        
        let baseURL = "https://openweathermap.org/img/wn/"
        let iconURLString = "\(baseURL)\(imageIcon)@2x.png"
        
        if let iconURL = URL(string: iconURLString) {
            let task = URLSession.shared.dataTask(with: iconURL) { data, response, error in
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        imageView.image = UIImage(data: data)
                       
                    }
                }else{
                    print("something went wrong! ")
                }
            }
            task.resume()
        }
    }

   
}


    
   
    
   
    
    

