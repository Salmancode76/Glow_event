//
//  SendHighlightsViewController.swift
//  Glow_event
//
//  Created by PRINTANICA on 24/12/2024.
//

import UIKit
import Firebase


class SendHighlightsViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        testFirebaseConnection()
        
        

        // Do any additional setup after loading the view.
    }
    
    func testFirebaseConnection(){
        
        Analytics.logEvent("test_event", parameters: [
                   "test_param": "test_value"
               ])
               print("Firebase test event logged")
           }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

