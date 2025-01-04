//
//  UserHome.swift
//  Glow_event
//
//  Created by PRINTANICA on 03/01/2025.
//

import UIKit
import Firebase
import FirebaseDatabase

class UserHome: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var selectedCategories: [String] = []
    var events: [Event] = []
    
    var filteredEvents: [Event] = [] // Array to hold filtered events
    var isSearching = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchEvents()
        
        searchbar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        fetchEvents()
        
        if let textField = searchbar.value(forKey: "searchField") as? UITextField {
            textField.textColor = UIColor.white // Change this to your desired color
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredEvents.count : events.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        let event = isSearching ? filteredEvents[indexPath.row] : events[indexPath.row]
        
        // Set the event details
        cell.eventName.text = event.name
        cell.eventLocation.text = event.location
        
        if let url = URL(string: event.imageURL) {
            cell.eventImage.loadImage(from: url)
        }
        
        
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredEvents.removeAll() // Clear filtered results
        } else {
            isSearching = true
            filteredEvents = events.filter { event in
                event.name.lowercased().contains(searchText.lowercased()) }
        }
        print("Filtered Events: \(filteredEvents)")
        tableView.reloadData() // Refresh the table view
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        filteredEvents.removeAll()
        tableView.reloadData()
        searchBar.resignFirstResponder() // Dismiss the keyboard
    }
    
    
    
    
    
    func fetchEvents() {
        
        let ref = Database.database().reference().child("events")
            ref.observeSingleEvent(of: .value) { snapshot in
                var fetchedEvents: [Event] = []

                // Check if the snapshot contains children
                guard snapshot.exists(), snapshot.childrenCount > 0 else {
                    print("No data available in 'events' node")
                    self.events = []
                    self.tableView.reloadData()
                    return
                   }

                   // Iterate over each child in the snapshot
                for child in snapshot.children {
                            if let childSnapshot = child as? DataSnapshot,
                               let eventData = childSnapshot.value as? [String: Any] {
                                
                                // Extract event details
                                let eventName = eventData["EventName"] as? String ?? "No Name"
                                let location = eventData["venue_options"] as? String ?? "No Location"
                                let imageURL = eventData["EventImg"] as? String ?? ""
                                let category = eventData["category"] as? String ?? "No Category"
                                
                                // Print debug information
                                print("Fetched Event: \(eventName), \(location)")

                                // Filter events by selected categories
                                if self.selectedCategories.isEmpty || self.selectedCategories.contains(category) {
                                    let event = Event(name: eventName, location: location, imageURL: imageURL, category: category)
                                    fetchedEvents.append(event)
                                }
                            }
                        }

                        // Update the events array and refresh the table view
                        self.events = fetchedEvents
                        print("Total Events Fetched: \(self.events.count)")
                        self.tableView.reloadData()
                    }
                }
        }
        
        // Do any additional setup after loading the view.
        
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    
