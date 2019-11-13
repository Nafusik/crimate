//
//  ChangeCityViewController.swift
//  crimate App
//
//  Created by Francesca Koulikov on 09/08/2019
//

import UIKit
import DatePickerDialog

//Write the protocol declaration here:
protocol ChangeCityDelegate {
    func userEnteredANewCityName (city : String)
}


class ChangeCityViewController: UIViewController {
    
    // Variables
    let datePicker = DatePickerDialog(
        textColor: .red,
        buttonColor: .red,
        font: UIFont.boldSystemFont(ofSize: 17),
        showCancelButton: true
    )
    var pickDate = ""
    
    
    //Declare the delegate variable here:
    var delegate : ChangeCityDelegate?
    
    //This is the pre-linked IBOutlets to the text field:
    
    @IBOutlet weak var cityEnteredText: UITextField!
    
    
    //MARK: - DatePickerDialog
    func datePickerTapped() {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.month = -3
        let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        
        datePicker.show("DatePickerDialog",
                        doneButtonTitle: "Done",
                        cancelButtonTitle: "Cancel",
                        minimumDate: threeMonthAgo,
                        maximumDate: currentDate,
                        datePickerMode: .date) { (date) in
                            if let dt = date {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                                self.pickDate = formatter.string(from: dt)
                            }
                    }
    }
    
    // buttons pressed
    
    
    @IBAction func pickADateButtonPressed(_ sender: UIButton) {
        datePickerTapped()
    }
    
}
