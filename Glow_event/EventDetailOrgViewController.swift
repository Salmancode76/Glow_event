import Foundation
import UIKit
class EventDetailOrgViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var EventDetailTableview: UITableView!
   // var event: Event?

  
    var eventPhotoURL: String?
    var eventDate: Date?
    var eventEndDate: Date?
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
            vc.eventName = self.eventName ?? ""
            
            vc.eventUrl = self.eventPhotoURL ?? ""
            
            vc.eventCategory = self.eventCategory ?? ""
            
            vc.eventPrice = self.eventPrice ?? 0
            
            vc.eventLocation = self.eventLocation ?? ""
            
            vc.eventCap = self.eventSeats ?? 0
            
            vc.eventAge = self.eventAgeGrp
            
            vc.eventDes = self.eventDes!
            
            vc.eventStatus = self.eventStatus!
            
            vc.eventID = self.eventID ?? ""
            
            vc.eventStartDate = self.eventDate ?? Date.now
            
            vc.eventEndDate = self.eventEndDate ?? Date.now
            
            
            
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBOutlet weak var DeleteEvent: UIButton!
    
    
    private func showFailAlert(errorMessage: String) {
        // Create an alert controller with a title and message indicating failure
        let alertController = UIAlertController(title: "Failure", message: "Failed to update the event. Error: \(errorMessage)", preferredStyle: .alert)
        
        // Add an OK button to dismiss the alert
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        
        // Present the alert
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func DeleteEvent(_ sender: Any) {
        
        
        
        FirebaseDB.deleteEvent(eventID: eventID ?? "") { [self] success, errorMessage in
            if success {
                
                self.navigationController?.popViewController(animated: true)
            } else {
                showFailAlert(errorMessage:"Error deleting event")
               
            }
        }
    }
        

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            // Reload data after the view has appeared
            self.EventDetailTableview.reloadData()
        }
    }
    


 
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
