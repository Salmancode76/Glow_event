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
    
    var selectedCategory: String? // Store the selected category


    var events: [Event] = [] // Array to hold all events from Firebase
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
             navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
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
        let count = searching ? searchEvents.count : filteredEvents.count
            return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = searching ? searchEvents[indexPath.row] : filteredEvents[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "event", for: indexPath) as! EventOrgTableViewCell
        
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        cell.backgroundColor = .black

        let selectedView = UIView()
        selectedView.backgroundColor = .darkGray
        cell.selectedBackgroundView = selectedView
        cell.EventName.textColor = .white

        // Placeholder image
        if let photoImage = UIImage(systemName: "photo.fill") {
            cell.setupCell(photo: photoImage, name: event.EventName, startDate: event.startDate, venu: event.venu_options)
        }

        // Download the image for the event
        let imagePath = event.EventPhotoURL
        let fullImageURL = imagePath

        CloudinarySetup.DownloadEventyImage(from: fullImageURL) { downloadedImage in
            if let image = downloadedImage {
                cell.EventImage.image = image
            } else {
                cell.EventImage.image = UIImage(systemName: "photo.fill") // Placeholder
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        let event = searching ? searchEvents[indexPath.row] : events[indexPath.row]

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
