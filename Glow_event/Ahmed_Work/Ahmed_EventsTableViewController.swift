//
//  Ahmed_EventsTableViewController.swift
//  Glow_event
//
//  Created by a-awadhi on 04/01/2025.
//

import UIKit

class Ahmed_EventsTableViewController: UITableViewController {
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    public func loadData() {
        FirebaseDB.GetAllEvents { events in
            self.events = events
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count > 0 ? 1 : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ahmed_eventCell", for: indexPath)
        
        let event = events[indexPath.section]
        
        if let title = cell.viewWithTag(10) as? UILabel {
            title.text = event.EventName
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
                
        let event = events[indexPath.section]
        
        let eventVC = storyboard?.instantiateViewController(withIdentifier: "Ahmed_EventViewController") as! Ahmed_EventViewController
        
        eventVC.configure(event: event, isBought: false)
        
        navigationController?.pushViewController(eventVC, animated: true)
        
        
    }
    
}
