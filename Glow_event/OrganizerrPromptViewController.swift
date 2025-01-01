//
//  OrganizerrPromptViewController.swift
//  Glow_event
//
//  Created by PRINTANICA on 01/01/2025.
//

import UIKit

class OrganizerrPromptViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func viewButton(_ sender: Any) {
        
        guard let organizerName = nameText.text, !organizerName.isEmpty else {
            // Show an alert if the name is empty
            showAlert(message: "Please enter the organizer's name.")
            return
        }
        
        performSegue(withIdentifier: "showHighlights", sender: organizerName)
    }
        
        
    
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "showHighlights",
              let destinationVC = segue.destination as? PhotosClassViewController,
              let organizerName = sender as? String {
               destinationVC.organizerName = organizerName // Pass the organizer name to the next VC
           }
       }
            private func showAlert(message: String) {
                    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alert, animated: true, completion: nil)
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
