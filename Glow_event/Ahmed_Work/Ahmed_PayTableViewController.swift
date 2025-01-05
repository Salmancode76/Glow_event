//
//  Ahmed_PayTableViewController.swift
//  Glow_event
//
//  Created by a-awadhi on 05/01/2025.
//

import UIKit

class Ahmed_PayTableViewController: UITableViewController {
    @IBOutlet weak var cvvField: UITextField!
    @IBOutlet weak var expiryField: UITextField!
    @IBOutlet weak var cardNumberField: UITextField!
    @IBOutlet weak var cardNameField: UITextField!
    
    private var paymentType = ""
    
    private var event: Event?
    private var quantity: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func configure(event: Event, quantity: Int) {
        self.event = event
        self.quantity = quantity
    }
    
    @IBAction func tappedPay(_ sender: Any) {
        guard let event = event, let quantity = quantity else { return }
        
        guard let cvv = cvvField.text,
              let expiry = expiryField.text,
              let cardNumber = cardNumberField.text,
              let name = cardNameField.text,
              !cvv.isEmpty,
              !expiry.isEmpty,
              !cardNumber.isEmpty,
              !name.isEmpty,
              !paymentType.isEmpty else {
            let alert = UIAlertController(title: "Error",
                                          message: "Please fill out all fields.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
            return
        }
        
        FirebaseDB.saveTicket(eventID: event.id, quantity: quantity, price: event.price * Double(quantity)) { _, _ in
            let alert = UIAlertController(title: "Payment Successful",
                                          message: "Your payment has been processed successfully.",
                                          preferredStyle: .alert)
            
            // Add a dismiss action that pops to the root and calls loadData
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
                // Navigate back to the root view controller
                if let navigationController = self?.navigationController {
                    navigationController.popToRootViewController(animated: true)
                    
                    // Cast the root view controller as Ahmed_EventsTableViewController and call loadData
                    if let rootVC = navigationController.viewControllers.first as? Ahmed_EventsTableViewController {
                        rootVC.loadData()
                    }
                }
            }))
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect the row with animation
        tableView.deselectRow(at: indexPath, animated: true)
        
        // we only want Payment option section
        guard indexPath.section == 0 else { return }
        
        if indexPath.row == 0 {
            // Set a checkmark for row 0, 0 and remove it from 0, 1
            if let cell00 = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
                cell00.accessoryType = .checkmark
                paymentType = "Credit"
            }
            if let cell01 = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) {
                cell01.accessoryType = .none
            }
        } else if indexPath.row == 1 {
            // Set a checkmark for row 0, 1 and remove it from 0, 0
            if let cell00 = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
                cell00.accessoryType = .none
            }
            if let cell01 = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) {
                cell01.accessoryType = .checkmark
                paymentType = "Debit"
            }
        }
    }
    
}
