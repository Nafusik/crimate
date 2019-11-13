//
//  MapViewController.swift
//
//  Created by Francesca Koulikov 09/11/2019
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import MapKit



class MapViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    //Constants
    let CRIME_API_URL = "https://api.crimeometer.com/v1/incidents/raw-data"
    let APP_ID = "k3RAzKN1Ag14xTPlculT39RZb38LGgsG8n27ZycG"
    var pickDate = ""
    
    
    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let crimeRateDataModel = CrimateDataModel()
    
    
    
    
    //Pre-linked IBOutlets

    
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
        let headers = [ "Content-Type": "application/json",
                        "x-api-key": APP_ID
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).responseJSON {
            response in
            if response.result.isSuccess{
                print("Success ! Got the crime Rate data")
                print (response)
                let crimeJSON : JSON = JSON(response.result.value!)
                
                self.updateCrimeRateData(json: crimeJSON)
                
            }
            else{
                print("Error \(response.result.error)")
                //self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    
    //Write the updateWeatherData method here:
    func updateCrimeRateData(json : JSON){
        
        print(json["total_incidents"])
        
        if let crimeResult = json["total_incidents"].int {
            
            crimeRateDataModel.totalIncident = crimeResult
            
            crimeRateDataModel.city = json["name"].stringValue
            crimeRateDataModel.crimeIconName = crimeRateDataModel.updateCrimeRateIcon(incidentTotal: crimeRateDataModel.totalIncident)
            
            updateUIWithCrimeRateData()
        }
        else{
            //cityLabel.text = "crime Rate Unavailable"
            print ("crime Rate Unavailable")
        }
    }
    
    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithCrimeRateData method here:
    func updateUIWithCrimeRateData(){
        //cityLabel.text = crimeRateDataModel.city
        //crimeRateLabel.text = "\(crimeRateDataModel.totalIncident)"
        //crimeIcon.image = UIImage(named: crimeRateDataModel.crimeIconName)
        print ("need to add to table View")
        
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        let date: Date = Date()
        let dateInThePass: Date = Date(timeIntervalSinceNow: 30)
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let currentDate = dateFormatterGet.string(from: date)
        let passDate = dateFormatterGet.string(from: dateInThePass)
        
        print (currentDate)
        print (passDate)
        
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            let params : [String : String] = ["lat" : String(latitude),
                                              "lon" : String(longitude),
                                              "distance": String(34),
                                              "datetime_ini": "\(passDate)",
                "datetime_end": "\(currentDate)"]
            
            getCrimeRateData(url: CRIME_API_URL, parameters: params)
            
            
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        //cityLabel.text = "Location Unavailable"
    }
    
    
    
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func userEnteredANewCityName(city: String) {
        
        //        let params : [String : String] = ["lat" : String(latitude),
        //                                          "lon" : String(longitude),
        //                                          "distance": String(34),
        //                                          "datetime_ini": "\(passDate)",
        //            "datetime_end": "\(currentDate)"]
        
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


