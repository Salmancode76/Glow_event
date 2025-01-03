import UIKit
import Firebase
import FirebaseDatabase

class HomeOrgViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    var events: [Event] = [] // Array to hold Event objects

 
    
    @IBOutlet weak var HomeNav: UINavigationItem!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searching ? searchEvents.count : events.count
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searching = false
        } else {
            searching = true
            searchEvents = events.filter { event in
                return event.EventName.lowercased().contains(searchText.lowercased())
            }
        }
        EventsOrgTable.reloadData() // Reload table view to display filtered results
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        let event = searching ? searchEvents[indexPath.row] : events[indexPath.row]

        if let vc = storyboard?.instantiateViewController(identifier: "EventDetailOrg") as? EventDetailOrgViewController {

            
            vc.eventName = event.EventName
            
            vc.eventDate = event.startDate
            
            vc.eventPhotoURL = event.EventPhotoURL
            
            vc.eventStatus = event.EventStatus
            
            vc.eventDes = event.descrip
            
            vc.eventSeats =  event.Capacity
            
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        // Dequeue the cell with the identifier "event"
        //let event = events[indexPath.row]
        
        let event = searching ? searchEvents[indexPath.row] : events[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "event", for: indexPath) as! EventOrgTableViewCell
        // Customize cell appearance (black background and white text)
        cell.textLabel?.textColor = .white // Set text color to white
        cell.detailTextLabel?.textColor = .white // Set detail text color to white
        cell.backgroundColor = .black // Set cell background color to black
        
        let selectedView = UIView()
        selectedView.backgroundColor = .darkGray // You can set any color for selection
        cell.selectedBackgroundView = selectedView
        cell.EventName.textColor = .white
        
        
        if let photoImage = UIImage(systemName: "photo.fill") {
            // Safely unwrap the UIImage and pass it to the setupCell method
            cell.setupCell(photo: photoImage,name: event.EventName,startDate: event.startDate, venu: event.venu_options)
        }
        
        
        cell.textLabel?.textColor = .white // Set text color to white
        cell.detailTextLabel?.textColor = .white // Set detail text color to white
        cell.backgroundColor = .black // Set cell background color to black
    
        
        let imagePath = event.EventPhotoURL // e.g., "event/images/2B84E488-B6BE-45BA-975F-F65AF2597EC2"
        let fullImageURL =  imagePath
        
        CloudinarySetup.DownloadEventyImage(from: fullImageURL) { downloadedImage in
            if let image = downloadedImage {
                // Set the downloaded image to the UIImageView
                cell.EventImage.image = image
            } else {
                self.showFailAlert(errorMessage: "Failed to download image")
                // Set a placeholder image in case the download fails
                cell.EventImage.image = UIImage(systemName: "photo.fill") // Placeholder
            }
        }

        
      
        
        
        return cell
    }
    private func showFailAlert(errorMessage: String) {
        // Create an alert controller with a title and message indicating failure
        let alertController = UIAlertController(title: "Failure", message: "Failed to update the event. Error: \(errorMessage)", preferredStyle: .alert)
        
        // Add an OK button to dismiss the alert
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        
        // Present the alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var EventsOrgTable: UITableView!
    
    @IBOutlet weak var EvnentsOrgTable: UITableView!
    
    
    
    var searchEvents : [Event] = []
    var searching = false
    
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false // Reset search state
        searchBar.text = "" // Clear the search bar
        searchBar.resignFirstResponder() // Dismiss the keyboard
        EventsOrgTable.reloadData() // Reload the table to show all events
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    
        FirebaseDB.GetAllEvents { [weak self] events in
            self?.events = events  // Store fetched events in the array
            self?.EventsOrgTable.reloadData()  // Reload the table view to display the events
        }
        
        if let navBar = self.navigationController?.navigationBar {
             navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
             navBar.tintColor = UIColor.white // For buttons on the navigation bar (e.g., back button)
         }
         
        
        // Set data source and delegate for the table view
        EventsOrgTable.dataSource = self
        EventsOrgTable.delegate = self
        
        self.EvnentsOrgTable.backgroundColor = .black
        self.EvnentsOrgTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Firebase reference to the events node
        
        

     
 
        
    }
}
