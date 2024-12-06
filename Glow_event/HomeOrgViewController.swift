import UIKit
import Firebase
import FirebaseDatabase

class HomeOrgViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var EventsOrgTable: UITableView!
    
    var events: [Event] = [] // Array to hold Event objects
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set data source and delegate for the table view
        EventsOrgTable.dataSource = self
        EventsOrgTable.delegate = self

        // Firebase reference to the events node
        let ref = Database.database(url: "https://glowevent-9be31-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
        
        // Observe the "events" node in Firebase
        ref.child("events").observe(.value, with: { snapshot in
            var fetchedEvents: [Event] = []
            
            // Loop through the snapshot and create Event objects
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                    let event = Event(snapshot: snapshot) // Initialize event with snapshot
                    fetchedEvents.append(event) // Add event to the array
                }
            }
            
            // Update the events array and reload the table view
            self.events = fetchedEvents
            self.EventsOrgTable.reloadData() // Reload table to display fetched data
        })
    }

    // UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count // Return the count of events to display
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = events[indexPath.row] // Get the event for this row
        
        // Dequeue the cell with the identifier "event"
        let cell = tableView.dequeueReusableCell(withIdentifier: "event", for: indexPath)
        
        // Set the cell text
        cell.textLabel?.text = event.EventName 
        cell.detailTextLabel?.text = "Date: \(event.startDate) - Venue: \(event.venu_options)"
        
        return cell
    }
}
