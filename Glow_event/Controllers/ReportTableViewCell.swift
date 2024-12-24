//
//  ReportTableViewCell.swift
//  Glow_event
//
//  Created by Thuraya AlSatrawi on 18/12/2024.
//

import UIKit

class AdminReportListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // TableView Outlet
    @IBOutlet weak var tableView: UITableView!
    
    // Example data source for reports
    let reports = [
        ["ReportID": "1", "Category": "Inappropriate", "EventID": "1"],
        ["ReportID": "2", "Category": "Misleading", "EventID": "23"],
        ["ReportID": "3", "Category": "Duplicate", "EventID": "45"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title of the ViewController
        self.title = "Reports"
        
        // Register the custom cell
        let nib = UINib(nibName: "ReportTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ReportCell")
        
        // Set delegates
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportTableViewCell
        
        // Populate the cell with dynamic data
        let report = reports[indexPath.row]
        cell.reportIDLabel.text = "Report ID: \(report["ReportID"]!)"
        
        return cell
    }
    
    // MARK: - TableView Delegate Method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected Report ID: \(reports[indexPath.row]["ReportID"]!)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
