//
//  Ahmed_TicketsTableViewController.swift
//  Glow_event
//
//  Created by Natheer on 06/01/2025.
//

import UIKit

class Ahmed_TicketsTableViewController: UITableViewController {
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Tickets"
        
        tableView.register(.init(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "ahmed_eventCell")
        
        
        FirebaseDB.getEventsForUserTickets { events in
            self.events = events
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FirebaseDB.getEventsForUserTickets { events in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ahmed_eventCell") as! EventTableViewCell
        
        let event = events[indexPath.section]
        
        cell.configure(event: event)
        
        return cell
    }
}
