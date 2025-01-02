//
//  EventDetailTableViewController.swift
//  Glow_events
//
//  Created by Raneem Al-Awadhi on 01/01/2025.
//

import UIKit

class EventDetailTableViewController: UITableViewController {
    
    private let reportOptions = ["Inappropriate Content", "Spam", "Offensive Language"]
    private var selectedOptions = [String]()
    private var isShowingReportOptions = false // Tracks if report options are being displayed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.black
        // Set up the navigation bar menu
        setupNavigationBarMenu()
        
        // Register the default UITableViewCell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setupNavigationBarMenu() {
        let reportAction = UIAction(title: "Report Event", image: UIImage(systemName: "flag"), handler: { _ in
            self.toggleReportOptions()
        })
        
        let rateAction = UIAction(title: "Rate", image: UIImage(systemName: "star"), handler: { _ in
            self.showRatingPopup()
        })
        
        let closeAction = UIAction(title: "Close", image: UIImage(systemName: "xmark"), handler: { _ in
            print("Close tapped")
        })
        
        let menu = UIMenu(title: "", options: .displayInline, children: [reportAction, rateAction, closeAction])
        let menuButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "ellipsis"), menu: menu)
        
        self.navigationItem.rightBarButtonItem = menuButton
    }
    
    private func toggleReportOptions() {
        isShowingReportOptions.toggle()
        tableView.reloadData()
    }
    
    @objc private func showRatingPopup() {
        let alertController = UIAlertController(
            title: "Enjoyed the SZA Live Event?",
            message: "Share your feedback to help us and other attendees.",
            preferredStyle: .alert
        )
        
        alertController.addTextField { textField in
            textField.placeholder = "Write a feedback (optional)"
        }
        
        let notNowAction = UIAlertAction(title: "Not Now", style: .cancel, handler: nil)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            if let feedback = alertController.textFields?.first?.text {
                print("Feedback submitted: \(feedback)")
            }
        }
        
        alertController.addAction(notNowAction)
        alertController.addAction(submitAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isShowingReportOptions ? reportOptions.count + 1 : 1 // Report options + Submit button
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if isShowingReportOptions {
            if indexPath.row < reportOptions.count {
                let option = reportOptions[indexPath.row]
                cell.textLabel?.text = selectedOptions.contains(option) ? "✅ \(option)" : "◻️ \(option)"
            } else {
                cell.textLabel?.text = "Submit"
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.textColor = .systemBlue
            }
        } else {
            cell.textLabel?.text = "Make Payment"
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .systemBlue
        }
        
        return cell
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if isShowingReportOptions {
            if indexPath.row < reportOptions.count {
                let option = reportOptions[indexPath.row]
                if selectedOptions.contains(option) {
                    selectedOptions.removeAll { $0 == option }
                } else {
                    selectedOptions.append(option)
                }
                tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
                submitReport()
            }
        } else {
            showPaymentPopup()
        }
    }
    
    private func submitReport() {
        let alertController = UIAlertController(
            title: "We appreciate your feedback.",
            message: "Our team will review this event shortly to ensure it meets our guidelines.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showPaymentPopup() {
        let alertController = UIAlertController(
            title: "Payment Successful",
            message: "Your payment was completed successfully.",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("Popup dismissed")
        }
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


