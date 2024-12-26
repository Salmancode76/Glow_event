//
//  SendHighlightsViewController.swift
//  Glow_event
//
//  Created by PRINTANICA on 24/12/2024.
//

import UIKit
import FirebaseDatabase

class SendHighlightsViewController: UIViewController {

    let databaseRef = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef.child("test").setValue("Hello, Firebase!") { error, _ in
               if let error = error {
                   print("Error writing to database: \(error.localizedDescription)")
               } else {
                   print("Data written successfully!")
               }
           }

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
