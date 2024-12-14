//
//  FilterTableViewController.swift
//  Glow_event
//
//  Created by BP-36-201-09 on 14/12/2024.
//

import UIKit
// Declare the protocol to be used for passing data back to SearchEventOrgViewController
protocol FilterTableViewControllerDelegate: AnyObject {
    func applyFilterWith(events: [Event])
}

class FilterTableViewController: UITableViewController {
    
    var selectedEventCategory: String?
    var events: [Event] = [] // Events passed from SearchEventOrgViewController
    
    var filteredEvents: [Event] = []
    weak var delegate: FilterTableViewControllerDelegate? // Delegate reference

    
    @IBOutlet weak var EventCatgory: UIButton!
    
    @IBAction func OptionFilterCategory(_ sender:UIAction) {
        
        self.selectedEventCategory = sender.title
        

        self.EventCatgory.setTitle(sender.title, for: .normal)
        let filteredEvents = events.filter { $0.EventCategory == selectedEventCategory }

        print("Filtered events: ", filteredEvents)

    }
    
    @IBAction func ApplyFilter(_ sender: Any) {
        filteredEvents = events.filter { $0.EventCategory.lowercased() == selectedEventCategory?.lowercased() }

        if let searchVC =
            storyboard?.instantiateViewController(withIdentifier: "SearchOrg") as? SearchEventOrgViewController{
            searchVC.events = filteredEvents
          //  self.navigationController?.pushViewController(searchVC, animated: true)
            navigationController?.popViewController(animated: true)

        }
        delegate?.applyFilterWith(events: filteredEvents)

            
        print("Pressed");
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        
        func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return 1
        }
        
       
        print(events);

    }
}
