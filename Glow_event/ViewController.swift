//
//  ViewController.swift
//  Glow_event
//
//  Created by BP-36-201-09 on 25/11/2024.
//

import UIKit
import Foundation

class ViewController: UIViewController  {

    @IBOutlet weak var priceLbl: UITextField!
    @IBOutlet weak var venu_options: UIButton!
    @IBOutlet weak var startpicker: UIDatePicker!
    @IBOutlet weak var endpicker: UIDatePicker!
    @IBOutlet weak var event_photo: UIButton!

    @IBOutlet weak var startDate: UIDatePicker!
    
    @IBOutlet weak var EventNameLbl: UITextField!
    
    @IBOutlet weak var decriptionLbl: UITextView!
    
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var event_status: UIButton!
    
    @IBAction func venu_options(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
      //  priceLbl.keyboardType =  UIKeyboardTypeNumberPad;

    
        startpicker.tintColor = .white
        startpicker.backgroundColor = .black
        
        
  

        
        startpicker.contentHorizontalAlignment = .left
        endpicker.contentHorizontalAlignment = .left
        
    
        
        
        // Set the tint color to white
       
        
    }
    
    @IBAction func optionSelection(_ sender:UIAction)
    {
        print(sender.title)
        self.venu_options.setTitle(sender.title, for: .normal)
    }
    @IBAction func optionSelectionEventStatus(_ sender:UIAction)
    {
        print(sender.title)
        self.event_status.setTitle(sender.title, for: .normal)
    }
   
    
    // Create event action
      @IBAction func CreateEvent(_ sender: Any) {
          guard let eventName = EventNameLbl.text, !eventName.isEmpty else {
              print("Event name is empty.")
              return
          }
          guard let selectedVenue = self.venu_options.title(for: .normal), !selectedVenue.isEmpty else {
                print("Venue is not selected.")
                return
            }
          guard let enteredPriceText = priceLbl.text, !enteredPriceText.isEmpty else {
              print("Price is empty.")
              return
          }

          // Attempt to convert the entered string to a Double
          guard let enteredPrice = Double(enteredPriceText) else {
              print("Invalid price format.")
              return
          }
          
          let startDateValue = startDate.date  // Getting Date from UIDatePicker
          
          let endDateValue = endDate.date
          
          // Initialize the Event struct with the values
          let event = Event(EventName: eventName, venu_options: selectedVenue, price: enteredPrice, startDate: startDateValue,endDate: endDateValue)
          


          // Print the event to verify
          print("Event created: \(event)")
      }
    
}
