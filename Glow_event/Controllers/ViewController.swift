//
//  ViewController.swift
//  Glow_event
//
//  Created by BP-36-201-09 on 25/11/2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var dropdownTableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker! // Added DatePicker outlet

    @IBOutlet weak var scrollView: UIView!
    func scrollView;.contentSize = CGSize(width: scrollView.frame.width, height: 1200)

    var isDropdownVisible = false
    let categories = ["Any", "Concerts", "Networking", "Sports", "Exhibitions", "Conferences", "Gaming"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set TableView Delegates
        dropdownTableView.delegate = self
        dropdownTableView.dataSource = self
        
        // Hide dropdown initially
        dropdownTableView.isHidden = true
        
        // Configure DatePicker
        configureDatePicker()
    }
    
    // MARK: - Configure DatePicker
    func configureDatePicker() {
        // Set preferred style
        datePicker.preferredDatePickerStyle = .wheels
        
        // Force light mode for visibility
        datePicker.overrideUserInterfaceStyle = .light
        
        // Add background color for better contrast
        datePicker.backgroundColor = .white
        
        // Ensure DatePicker is fully visible
        datePicker.isHidden = false
        datePicker.alpha = 1.0
    }

    // MARK: - Button Action
    @IBAction func toggleDropdown(_ sender: UIButton) {
        // Toggle dropdown visibility
        isDropdownVisible.toggle()
        dropdownTableView.isHidden = !isDropdownVisible
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = categories[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
        return cell
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        print("Selected Category: \(selectedCategory)")
        
        // Hide dropdown after selection
        dropdownTableView.isHidden = true
        isDropdownVisible = false
    }

}
