//
//  Ahmed_CartViewController.swift
//  Glow_event
//
//  Created by a-awadhi on 05/01/2025.
//

import UIKit

class Ahmed_CartViewController: UIViewController {
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    private var event: Event?
    private var count = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let event = event else { return }
        
        
        nameLabel.text = event.EventName
        priceLabel.text = String(event.price)
        countLabel.text = "Number of Tickets: \(count)"
        totalPriceLabel.text = "Price: \(event.price * Double(count)) BD"
        
    }
    
    public func configure(event: Event) {
        self.event = event
    }
    @IBAction func tappedStepper(_ sender: UIStepper) {
        guard let event = event else { return }
        
        if sender.value > 0 {
            count = Int(sender.value)
        }
        
        countLabel.text = "Number of Tickets: \(count)"
        totalPriceLabel.text = "Price: \(event.price * Double(count)) BD"
    }
    
    @IBAction func tappedPay(_ sender: Any) {
        guard let event = event else { return }
        
        let payVC = storyboard?.instantiateViewController(withIdentifier: "Ahmed_PayTableViewController") as! Ahmed_PayTableViewController
        
        payVC.configure(event: event, quantity: count)
        
        navigationController?.pushViewController(payVC, animated: true)
    }
}
