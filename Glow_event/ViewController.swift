//
//  ViewController.swift
//  Glow_event
//
//  Created by BP-36-201-09 on 25/11/2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var event_photo: UIButton!
    @IBOutlet weak var start_dtpicker: UIDatePicker!

    
    @IBAction func Button(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        event_photo.layer.cornerRadius = 5
        start_dtpicker.setValue(UIColor.white, forKey: "textColor")
        
        
        // Set the tint color to white
       
        
    }
    
   
    
  
}


