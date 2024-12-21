import Foundation
import UIKit
class EventDetailOrgViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var EventDetailTableview: UITableView!
    // Table view outlet

    // Variables to hold event data (these will be passed from the previous view controller)
    var eventPhotoURL: String?
    var eventDate: Date?
    var eventName: String?
    var eventDes: String?
    var eventStatus: String?
    var eventSeats: Int?
    var eventPrice: Double?
    var eventLocation: String?
    var eventID: String?
    var eventCategory : String?
    var eventAgeGrp : String = ""

    
    @IBAction func EditEvnt(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "EditEventOrg") as? EditEventTableViewController {
            
            // Pass data to the edit page
            vc.eventName = self.eventName ?? "" // Ensure it's not nil
            
            vc.eventUrl = self.eventPhotoURL ?? ""
            
            vc.eventCategory = self.eventCategory ?? ""
            
            vc.eventPrice = self.eventPrice ?? 0
            
            vc.eventLocation = self.eventLocation ?? ""
            
            vc.eventCap = self.eventSeats ?? 0
            
            vc.eventAge = self.eventAgeGrp
            
            vc.eventDes = self.eventDes!
            
            vc.eventStatus = self.eventStatus!
            
            print("Event Name: \(self.eventName ?? "No Name")")
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBOutlet weak var DeleteEvent: UIButton!
    
    
    @IBAction func DeleteEvent(_ sender: Any) {
        
        FirebaseDB.deleteEvent(eventID: eventID ?? "") { success, errorMessage in
            if success {
                print("Event deleted successfully")
                
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Error deleting event: \(errorMessage ?? "Unknown error")")
                let alert = UIAlertController(title: "Error", message: "Could not delete the event. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the table view data source and delegate
        EventDetailTableview.delegate = self
        EventDetailTableview.dataSource = self
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1  // As you are showing the event details in a single row
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventDetailOrgTableViewCell", for: indexPath) as! EventDetailOrgTableViewCell

        // Set the cell background color to black
             cell.backgroundColor = .black
             
             // Set the selected background color (when the cell is tapped)
             let selectedView = UIView()
             selectedView.backgroundColor = .darkGray // Set selection color
             cell.selectedBackgroundView = selectedView
        
        // Configure the cell using the data passed to this view controller
        cell.setupCell(name: eventName ?? "No Name",
                       startDate: eventDate ?? Date(),
                       venu: eventLocation ?? "No Location",
                       status: eventStatus ?? "No Status",
                       seats: eventSeats ?? 0,
                       description: eventDes ?? "No Description",
                       price: eventPrice ?? 0.0,
                       location: eventLocation ?? "No Location",
                       photoURL: eventPhotoURL ?? "")

        return cell
    }
    
    
    
}
