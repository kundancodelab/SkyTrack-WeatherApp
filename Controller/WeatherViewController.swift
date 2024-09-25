
protocol showAlertViewDelagate {
    func showLocationServicesDeniedAlert(tilte: String, messege: String)
}

import UIKit
import Reachability
import CoreLocation
import AVFoundation

class WeatherViewController: UIViewController, showAlertViewDelagate {
    
    
    @IBOutlet weak var uiDatePicker: UIDatePicker!
    
    @IBOutlet weak var timeLable: UILabel!
    
    @IBOutlet var backgroundVideoView: UIView!
    
    @IBOutlet weak var humiditySpeed: UILabel!
    
    @IBOutlet weak var windsppedLabel: UILabel!
    
    @IBOutlet weak var weatherDescriptionLable: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var TempratureLabel: UILabel!
    @IBOutlet weak var CityLabel: UILabel!
    var  citynameCameFromFirstViewController:String?
    var locationManager = CLLocationManager()
    
    var weathermanager = WeatherManager()
   
    let reachability = try! Reachability()
    
    var lat:CLLocationDegrees? = nil
    var lon:CLLocationDegrees? = nil
    var status = true
    
    // MARK: - ViewDidLoad() method starts from here.
    override func viewDidLoad() {
        super.viewDidLoad()
        //uiDatePicker.isHidden = true
        let date = Date()
        uiDatePicker.date = date
        uiDatePicker.addTarget(self, action: #selector(datefunction(_:)), for: .valueChanged)
        
        datefunction(uiDatePicker)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
         

        // Do any additional setup after loading the view.
        weathermanager.delegate = self
        weathermanager.sencondDelegate = self
        searchTextField.delegate = self
      
        if let cityname = citynameCameFromFirstViewController {
            searchTextField.text = citynameCameFromFirstViewController
            weathermanager.fetchWeather(cityname: cityname)
          
        }else{
            status = false
        }
        
        if let lt = lat , let ln = lon {
            print(lt)
            print(ln)
            weathermanager.fetchWeather(latitute: lt, longitute: ln)
        }else{
            status = false
        }
       // setupBackgroundVideo()
        

    }
    
    @objc func datefunction(_ sender:UIDatePicker){
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a" // Format for hours, minutes, and am/pm
            
        let selectedTime = sender.date
            let formattedTime = dateFormatter.string(from: selectedTime)
         timeLable.text = formattedTime
        print(formattedTime)
        
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showinternetConnectivity()
        
    }
    
      
    
    
    deinit{
        reachability.stopNotifier()   // useful to deleting the memory.
        
        
    }
    
  func   showinternetConnectivity(){
      DispatchQueue.main.async {
          
          self.reachability.whenReachable = { reachability in
              if reachability.connection == .wifi {
                  print("Reachable via WiFi")
              } else {
                  print("Reachable via Cellular")
              }
              self.view.window?.rootViewController?.dismiss(animated: true)
          }
          self.reachability.whenUnreachable = { _ in
//              if let vc  = self.storyboard?.instantiateViewController(identifier: "NetworkErrorVC") as? NetworkErrorVC {
//                  self.present(vc, animated: true, completion: nil)
              self.showNoInternetAlert()
             }
         
          
          // show alert action when user is not connected to the internet.
          
         //
          do {
              try self.reachability.startNotifier()
          } catch {
              print("Unable to start notifier")
          }
      }
    }
    
    
    func showNoInternetAlert() {
            let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
      
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
        let lat:CLLocationDegrees = 22.5697
        let lon:CLLocationDegrees = 88.3697
        weathermanager.fetchWeather( latitute:lat, longitute:lon)
        searchTextField.text = ""
    }
    
    

}

// MARK: - UITextFieldDelagate

extension WeatherViewController:UITextFieldDelegate{
    
    
    
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        showinternetConnectivity()
        searchTextField.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
       searchTextField.endEditing(true)
              
       
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
        
        if let cityname = textField.text {
            showinternetConnectivity()
            weathermanager.fetchWeather(cityname: cityname)
           // CityLabel.text = cityname
        }else{
            print("invalid city name typed")
        }
        
        searchTextField.text = ""
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Something went wrong!!!")
        searchTextField.text = ""
    }
  
}


// MARK: - WeatherManagerDelegate
extension WeatherViewController:WeatherManagerDelegate {
    
    func didupdateWeather(weather:WeatherModel){
        
        //print(weather.temprature)
        DispatchQueue.main.async {
            self.TempratureLabel.text = weather.tempratureString
            self.CityLabel.text = weather.cityName
           // self.conditionImageView.image = UIImage(systemName: weather.conditionString)
           // print(weather.weatherIcon)
            self.weathermanager.setWeatherIcon(weather.weatherIcon,self.conditionImageView)
            self.weatherDescriptionLable.text = weather.description
            self.windsppedLabel.text = weather.windSpeed + "Km"
            self.humiditySpeed.text = weather.humdity
        }
                
        
    }
}

extension WeatherViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print(lat)
            print(lon)
            weathermanager.fetchWeather( latitute:lat, longitute:lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           if let clError = error as? CLError, clError.code == .denied {
               let title =  "Location Services Disabled"
               let  message =  "Please enable location services in settings to allow the app to access your location."
               showLocationServicesDeniedAlert(tilte: title, messege: message)
           } else {
               print("error is coming from here.")
               print(error)
           }
       }

       func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
           switch status {
           case .notDetermined:
               // Authorization not determined yet
               print("Location permission not determined")
           case .restricted, .denied:
               // Authorization denied or restricted
               print("Location permission denied or restricted")
              let title =  "Location Services Disabled"
              let  message =  "Please enable location services in settings to allow the app to access your location."
               
               showLocationServicesDeniedAlert(tilte: title, messege: message)
           case .authorizedWhenInUse, .authorizedAlways:
               // Authorization granted
               print("Location permission granted")
               locationManager.requestLocation()
           @unknown default:
               fatalError("Unknown location authorization status")
           }
       }

    func showLocationServicesDeniedAlert(tilte:String, messege:String) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: tilte,
                message: messege,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
           
       }
}

