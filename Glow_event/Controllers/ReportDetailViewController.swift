//
//  ReportDetailViewController.swift
//  Glow_event
//
//  Created by Thuraya AlSatrawi on 18/12/2024.
//

import UIKit

class ReportDetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

    // Outlets for the labels (Report Details)
    @IBOutlet weak var reportIDLabel: UILabel!
    @IBOutlet weak var eventIDLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var problemLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // Dynamic variables
    var reportID: String?
    var eventID: String?
    var username: String?
    var problem: String?
    var date: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set data for labels
        reportIDLabel.text = "Report ID: \(reportID ?? "N/A")"
        eventIDLabel.text = "Event ID: \(eventID ?? "N/A")"
        usernameLabel.text = "Username: \(username ?? "N/A")"
        problemLabel.text = "Problem: \(problem ?? "N/A")"
        dateLabel.text = "Date: \(date ?? "N/A")"
    }
    
@IBAction func deleteButtonTapped(_ sender: UIButton) {
    // Show confirmation alert for delete
    let alert = UIAlertController(
        title: "Are you sure you want to delete this report?",
        message: "Once deleted, this report cannot be restored",
        preferredStyle: .alert
    )
    
    // Yes Action
    let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
        // Show success message after deleting
        self.showDeletionSuccessAlert()
    }
    
    // No Action
    let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
    
    // Add actions to the alert
    alert.addAction(yesAction)
    alert.addAction(noAction)
    
    // Present the delete confirmation alert
    self.present(alert, animated: true, completion: nil)
}

// MARK: - Deletion Success Alert
func showDeletionSuccessAlert() {
    let successAlert = UIAlertController(
        title: "Report Deleted Successfully",
        message: "The report has been removed",
        preferredStyle: .alert
    )
    
    // OK Action to dismiss the alert and navigate back
    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
        // Navigate back to the previous screen
        self.navigationController?.popViewController(animated: true)
    }
    
    successAlert.addAction(okAction)
    self.present(successAlert, animated: true, completion: nil)
}
