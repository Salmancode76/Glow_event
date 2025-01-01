//
//  SearchEventOrgViewController.swift
//  Glow_event
//
//  Created by BP-36-201-09 on 11/12/2024.
//
import UIKit
import Firebase
import FirebaseDatabase

class SearchEventOrgViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var EventsOrgTable: UITableView!
    
    var selectedCategory: String? //Store the selected category

    var events: [Event] = [] // Array to hold all UNFILTERED events from Firebase
    
      var filteredEvents: [Event] = [] // Array to hold filtered events
      
      var searchEvents: [Event] = []
    var searching = false
    
    @IBAction func openFilterPage(_ sender: UIButton) {
        // Instantiate the FilterTableViewController from storyboard
        if let filterVC = storyboard?.instantiateViewController(withIdentifier: "FilterPageOrg") as? FilterTableViewController {
            
            // Pass the events data to the filter view controller
            filterVC.events = events
            filterVC.delegate = self

            
            // Present the filter view controller
            self.navigationController?.pushViewController(filterVC, animated: true)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navBar = self.navigationController?.navigationBar {
            // Change the color of the title text in the navigation bar to white

             navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            // Change the color of the navigation bar buttons (back button, etc.) to white

             navBar.tintColor = UIColor.white
         }
         

        // Set the data source and delegate for the table view
        EventsOrgTable.dataSource = self
        EventsOrgTable.delegate = self
        
        // Set up the search bar delegate
        searchBar.delegate = self
        
        
        if events.isEmpty{
            // Firebase reference to get all events
            FirebaseDB.GetAllEvents { [weak self] events in
                self?.events = events  // Store fetched events in the array
                self?.filteredEvents = events  // Set filtered events to the same initially
                self?.EventsOrgTable.reloadData()  // Reload the table view to display events
            }
        }
        
        
        // Customize table view appearance
        self.EventsOrgTable.backgroundColor = .black
        self.EventsOrgTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - UITableViewDataSource Methods

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Determine whether we are searching or not
           // If searching, return the count of searchResults, else return the count of filtered events
        let count = searching ? searchEvents.count : filteredEvents.count
            return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Select the event to display based on whether searching or filtering
        let event = searching ? searchEvents[indexPath.row] : filteredEvents[indexPath.row]

        // Dequeue the cell for reuse, cast it to the custom EventOrgTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "event", for: indexPath) as! EventOrgTableViewCell

        // Set text label color to white for better contrast
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        // Set the background color to black
        cell.backgroundColor = .black

        // Set the background view when the cell is selected
        let selectedView = UIView()
        selectedView.backgroundColor = .darkGray
        cell.selectedBackgroundView = selectedView
        // Set the text color for the Event Name label
        cell.EventName.textColor = .white

        // Placeholder image setup (in case the event image is not available)
        if let photoImage = UIImage(systemName: "photo.fill") {
            // Setup the cell with event data (image placeholder, name, date, venue)
            cell.setupCell(photo: photoImage, name: event.EventName, startDate: event.startDate, venu: event.venu_options)
        }

        // Download the actual image for the event from the URL
        let imagePath = event.EventPhotoURL
        let fullImageURL = imagePath

        // Fetch the image using the CloudinarySetup helper
        CloudinarySetup.DownloadEventyImage(from: fullImageURL) { downloadedImage in
            // If an image was downloaded, set it to the EventImage view
            if let image = downloadedImage {
                cell.EventImage.image = image
            } else {
                // If no image is available, set a default placeholder image
                cell.EventImage.image = UIImage(systemName: "photo.fill")
            }
        }

        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        
        let event: Event
        
        if searching {
            // When searching, use the searchResults
            event = searchEvents[indexPath.row]
        } else {
            // When not searching, use the filteredEvents or events
            event = filteredEvents.isEmpty ? events[indexPath.row] : filteredEvents[indexPath.row]
        }
        if let vc = storyboard?.instantiateViewController(identifier: "EventDetailOrg") as? EventDetailOrgViewController {

            
            vc.eventName = event.EventName
            
            vc.eventDate = event.startDate
            
            vc.eventPhotoURL = event.EventPhotoURL
            
            vc.eventStatus = event.EventStatus
            
            vc.eventDes = event.descrip
            
            vc.eventSeats =  (event.Capacity)
            
            vc.eventPrice = event.price
            
            vc.eventLocation = event.venu_options
                
            vc.eventID = event.id
            
            vc.eventCategory = event.EventCategory
            
            vc.eventAgeGrp = event.AgeGroup ?? "Any"
            
            vc.eventID = event.id
            
            vc.eventEndDate = event.endDate

            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        
    }


    // MARK: - UISearchBarDelegate Methods

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searching = false
        } else {
            searching = true
            // Search within filtered events, not the entire list
            searchEvents = filteredEvents.filter { event in
                return event.EventName.lowercased().contains(searchText.lowercased())
            }
        }
        EventsOrgTable.reloadData() // Reload table view to display filtered results
    }



    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false // Reset search state
        searchBar.text = "" // Clear the search bar
        searchBar.resignFirstResponder() // Dismiss the keyboard
        EventsOrgTable.reloadData() // Reload the table to show all events
    }
    // MARK: - Delegate Method for Filter

    
   
   }

   extension SearchEventOrgViewController: FilterTableViewControllerDelegate {
       // Implement the delegate method to apply the filtered events
       func applyFilterWith(events: [Event]) {
           self.filteredEvents = events
           self.EventsOrgTable.reloadData() // Reload table with filtered events
       }

   }
