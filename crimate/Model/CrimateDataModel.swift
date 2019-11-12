//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Francesca Koulikov
//

import UIKit

class CrimateDataModel {
    
    //Declare your model variables here
    var totalIncident : Int = 0
    var city : String = ""
    var crimeIconName : String = ""
    
    
    
    func updateCrimeRateIcon(incidentTotal: Int) -> String {
        
        switch (incidentTotal) {
            
        case 0...10 :
            return "black"
            
        case 11...50 :
            return "embarrassed"
            
        case 51...100 :
            return "scared"
            
        case 100...1000 :
            return "fire"
            
        default :
            return "dunno"
        }
        
    }
}
