//
//  AdminReportListViewController.swift
//  Glow_event
//
//  Created by Thuraya AlSatrawi on 18/12/2024.
//

import UIKit

class AdminReportListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Example Data
    let reports = [
        ["ReportID": "1", "Category": "Inappropriate", "EventID": "1", "Username": "John_Doe", "Date": "10/20/2024"],
        ["ReportID": "2", "Category": "Misleading", "EventID": "23", "Username": "Angela_Summers", "Date": "10/22/2024"],
        ["ReportID": "3", "Category": "Duplicate", "EventID": "45", "Username": "David_Smith", "Date": "10/25/2024"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Navigation Title
        self.title = "Reports"
        
        // Register the UITableViewCell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ReportCell")
        
        // Set TableView data source and delegate
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath)
        
        // Get the report data
        let report = reports[indexPath.row]
        
        // Set cell text
        cell.textLabel?.text = "Report ID: \(report["ReportID"] ?? "")"
        cell.detailTextLabel?.text = "Problem: \(report["Category"] ?? "")"
        cell.accessoryType = .disclosureIndicator // Adds the arrow on the right
        
        return cell
    }
    
    // MARK: - TableView Delegate Method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected report data
        let report = reports[indexPath.row]
        
        // Navigate to ReportDetailViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "ReportDetailViewController") as? ReportDetailViewController {
            
            // Pass data to ReportDetailViewController
            detailVC.reportID = report["ReportID"]
            detailVC.eventID = report["EventID"]
            detailVC.username = report["Username"]
            detailVC.problem = report["Category"]
            detailVC.date = report["Date"]
            
            // Push to the detail view
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
