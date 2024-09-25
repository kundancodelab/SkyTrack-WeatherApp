//
//  WeatherEntryViewController.swift
//  SkyTracker
//
//  Created by Kundan ios dev  on 06/07/24.
//

import UIKit
import CoreLocation
import AVFoundation
class WeatherEntryViewController: UIViewController {

    @IBOutlet var videoBackgroundView: UIView!
   
    
    @IBOutlet weak var searchCityNameTextField: UITextField!
    
    @IBOutlet weak var currentLocationButtonPressed: UIButton!
    let locationManager = CLLocationManager()
    var weathermanager = WeatherManager()
    var delegate:WeatherViewController?
    var secondDelegate:WeatherManagerDelegate?
    var weatherdata:WeatherModel?
    var lat:CLLocationDegrees?
    var lon:CLLocationDegrees?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        // Do any additional setup after loading the view.
        locationManager.requestAlwaysAuthorization()
        searchCityNameTextField.delegate = self
      
        
        
    }
 
    
    
    @IBAction func addCurrentLocationTapped(_ sender: UIButton) {
        locationManager.requestLocation()
      
        let vc = self.storyboard?.instantiateViewController(identifier: "WeatherViewController") as! WeatherViewController
        vc.lat = 22.5744
        vc.lon = 88.3629
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


extension WeatherEntryViewController:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           if let location = locations.first {
              // fetchWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
               lat = location.coordinate.latitude
               lon = location.coordinate.longitude
             
           }
       }
       
       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("Failed to find user's location: \(error.localizedDescription)")
       }
}

extension WeatherEntryViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchCityNameTextField.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchCityNameTextField.text =  ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField.text != ""  {
           
            return true
        }else{
            textField.placeholder = "Write Valid Location"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cityname = searchCityNameTextField.text {
            
            let vc = self.storyboard?.instantiateViewController(identifier: "WeatherViewController") as! WeatherViewController
            vc.citynameCameFromFirstViewController = cityname
            self.navigationController?.pushViewController(vc, animated: true)
          
            
        }else{
           // showAlert()
            delegate?.showLocationServicesDeniedAlert(tilte: "invaild", messege: "invalid city name typed")
        }
    }
    func showAlert() {
            let alert = UIAlertController(title: "Invalid City", message: "Invalid city name", preferredStyle: .alert)
            
            // Add an "OK" button
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            // Present the alert
            present(alert, animated: true, completion: nil)
        }
    
}
