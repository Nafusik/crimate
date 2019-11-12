//
//  ViewController.swift
//  WeatherApp
//
//  Created by Francesca Koulikov 09/11/2019
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class CrimateViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    //Constants
    let CRIME_API_URL = "https://api.crimeometer.com/"
    let APP_ID = ""
    
    
    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let crimeRateDataModel = CrimeRateDataModel()
    
    
    
    //Pre-linked IBOutlets
    @IBOutlet weak var crimeRateLabel: UILabel!
    @IBOutlet weak var crimeIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getCrimeRateData(url: String, parameters: [String: String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess{
                print("Success ! Got the crime Rate data")
                let weatherJSON : JSON = JSON(response.result.value!)
                
                self.updateCrimeRateData(json: weatherJSON)
                
            }
            else{
                print("Error \(response.result.error)")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    
    //Write the updateWeatherData method here:
    func updateCrimeRateData(json : JSON){
        
        if let crimeResult = json["main"]["temp"].int {
            
            crimeRateDataModel.totalIncident = crimeResult
            
            crimeRateDataModel.city = json["name"].stringValue
            crimeRateDataModel.crimeIconName = crimeRateDataModel.updateCrimeRateIcon(incidentTotal: crimeRateDataModel.totalIncident)
            
            updateUIWithCrimeRateData()
        }
        else{
            cityLabel.text = "crime Rate Unavailable"
        }
    }
    
    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithCrimeRateData method here:
    func updateUIWithCrimeRateData(){
        cityLabel.text = crimeRateDataModel.city
        var crimeRate = ""
        crimeRateLabel.text = "\(crimeRate)°"
        crimeIcon.image = UIImage(named: crimeRateDataModel.crimeIconName)
        
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            let params : [String : String] = ["lat" : String(latitude),
                                              "lon" : String(longitude),
                                              "appid" : APP_ID]
            
            getCrimeRateData(url: CRIME_API_URL, parameters: params)
            
            
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    
    
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func userEnteredANewCityName(city: String) {
        
        let params : [String: String] = ["q" : city, "appid" : APP_ID]
        
        getCrimeRateData(url: CRIME_API_URL, parameters: params)
        
        
    }
    
    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName"{
            let destinationVC = segue.destination as! ChangeCityViewController
            
            destinationVC.delegate = self
        }
    }
    
    // Function that does things
    
}


