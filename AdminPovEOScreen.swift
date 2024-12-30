//
//  AdminPovEOScreen.swift
//  Glow_event
//
//  Created by Thuraya AlSatrawi on 19/12/2024.
//

import UIKit

class AdminPovEOScreen: UIViewController {
    
    // IBOutlets for your UI elements (if needed)
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional setup if needed
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        let confirmationAlert = UIAlertController(
            title: "Are you sure you want to delete this account?",
            message: "Deleting this account is permanent and cannot be recovered.",
            preferredStyle: .alert
        )
        
        confirmationAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            self.deleteOrganizer()
        }))
        
        confirmationAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
    func deleteOrganizer() {
        // Perform deletion logic here
        print("Organizer deleted!") // Replace with your deletion logic
        
        let successAlert = UIAlertController(
            title: "Organizer Deleted Successfully",
            message: "The organizer has been removed.",
            preferredStyle: .alert
        )
        
        successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(successAlert, animated: true, completion: nil)
    }
}

