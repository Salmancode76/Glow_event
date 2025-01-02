//
//  EventDetailViewController.swift
//  Glow_events
//
//  Created by Raneem Al-Awadhi on 01/01/2025.
//

import UIKit

class EventDetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the actions for the menu
        let reportAction = UIAction(title: "Report Event", image: UIImage(systemName: "flag"), handler: { _ in
            self.showReportEventPage()
        })

        let rateAction = UIAction(title: "Rate", image: UIImage(systemName: "star"), handler: { _ in
            self.showRatingPopup()
        })

        let closeAction = UIAction(title: "Close", image: UIImage(systemName: "xmark"), handler: { _ in
            print("Close tapped")
        })

        // Create the menu
        let menu = UIMenu(title: "", options: .displayInline, children: [reportAction, rateAction, closeAction])

        // Create the bar button item with the menu
        let menuButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "ellipsis"), menu: menu)

        // Set the button as the right bar button item
        self.navigationItem.rightBarButtonItem = menuButton

        // Add a "Payment Successful" button
        setupPaymentButton()
    }

    private func setupPaymentButton() {
        // Create a button programmatically
        let paymentButton = UIButton(type: .system)
        paymentButton.setTitle("Make Payment", for: .normal)
        paymentButton.addTarget(self, action: #selector(showPaymentPopup), for: .touchUpInside)

        // Add the button to the view
        paymentButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(paymentButton)

        // Center the button in the view
        NSLayoutConstraint.activate([
            paymentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            paymentButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func showPaymentPopup() {
        // Create the alert controller
        let alertController = UIAlertController(
            title: "Payment Successful",
            message: "Your payment was completed successfully.",
            preferredStyle: .alert
        )

        // Add an "OK" action to dismiss the popup
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("Popup dismissed")
        }
        alertController.addAction(okAction)

        // Present the alert controller
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Report Event Page
    func showReportEventPage() {
        let reportEventVC = ReportEventViewController()
        navigationController?.pushViewController(reportEventVC, animated: true)
    }

    // MARK: - Rating Popup
    func showRatingPopup() {
        // Create the alert controller
        let alertController = UIAlertController(
            title: "Enjoyed the SZA Live Event?",
            message: "Share your feedback to help us and other attendees.",
            preferredStyle: .alert
        )

        // Add a text field for optional feedback
        alertController.addTextField { textField in
            textField.placeholder = "Write a feedback (optional)"
        }

        // Add actions
        let notNowAction = UIAlertAction(title: "Not Now", style: .cancel, handler: nil)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            if let feedback = alertController.textFields?.first?.text {
                print("Feedback submitted: \(feedback)")
            }
        }

        alertController.addAction(notNowAction)
        alertController.addAction(submitAction)

        // Present the alert
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Report Event View Controller
class ReportEventViewController: UIViewController {
    private var selectedOptions = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Report Event"

        // Example options for reporting
        let reportOptions = ["Inappropriate Content", "Spam", "Offensive Language"]

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10

        // Create option buttons
        for option in reportOptions {
            let button = UIButton(type: .system)
            button.setTitle(option, for: .normal)
            button.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }

        // Submit button
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(submitReport), for: .touchUpInside)
        stackView.addArrangedSubview(submitButton)

        // Add stackView to view
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        // Constraints
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    @objc private func optionSelected(_ sender: UIButton) {
        guard let option = sender.titleLabel?.text else { return }
        if selectedOptions.contains(option) {
            selectedOptions.removeAll { $0 == option }
            sender.setTitle("◻️ \(option)", for: .normal)
        } else {
            selectedOptions.append(option)
            sender.setTitle("✅ \(option)", for: .normal)
        }
    }

    @objc private func submitReport() {
        // Show the confirmation popup
        let alertController = UIAlertController(
            title: "We appreciate your feedback.",
            message: "Our team will review this event shortly to ensure it meets our guidelines.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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


