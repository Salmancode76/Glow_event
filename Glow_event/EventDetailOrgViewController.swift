import UIKit
import FirebaseDatabaseInternal

class EventDetailOrgViewController: UIViewController {

    // Outlets for the UI components
    @IBOutlet weak var EventName: UILabel!
    @IBOutlet weak var EventStatus: UILabel!
    @IBOutlet weak var EventDate: UILabel!
    @IBOutlet weak var EventSeatslbl: UILabel!
    @IBOutlet weak var EventPhoto: UIImageView!
    @IBOutlet weak var EventDesclbl: UILabel!
    @IBOutlet weak var Pricelbl: UILabel!
    @IBOutlet weak var EventLocation: UILabel!

    // Variables to hold event data (these will be passed from the previous view controller)
    var eventPhotoURL: String?
    var eventDate: Date?
    var eventName: String?
    var eventDes: String?
    var eventStatus: String?
    var eventSeats: Int?
    var eventPrice: Double?
    var eventLocation: String?
    
    var eventID : String?

   
    @IBAction func DeleteEvent(_ sender: Any) {
        guard let eventID = eventID else {
            print("Event ID is missing!")
            return
        }
        
        // Reference to the specific event in Firebase using the eventID
        let eventRef = FirebaseDB.ref.child("events").child(eventID)
        
        // Remove the event from Firebase
        eventRef.removeValue { error, _ in
            if let error = error {
                // If there's an error, print it
                print("Failed to delete event: \(error.localizedDescription)")
            } else {
                // Successfully deleted the event
                print("Event deleted successfully!")
                // Optionally, you could navigate back or show a confirmation message
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    @IBOutlet weak var DeleteBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the UI components with event data passed from the previous view controller
        EventLocation.text = eventLocation
        EventName.text = eventName
        EventStatus.text = eventStatus
        EventDesclbl.text = eventDes
        EventSeatslbl.text = "Seats Available: \(eventSeats ?? 0)"

        // Format and display price as currency
        if let price = eventPrice {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            Pricelbl.text = formatter.string(from: NSNumber(value: price))
        }

        // Format the date into a string
        if let eventDate = eventDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, MMM dd • h:mm a"
            EventDate.text = dateFormatter.string(from: eventDate)
        } else {
            EventDate.text = "No Date Available"
        }

        // Load the event image from the URL
        if let photoURL = eventPhotoURL {
            CloudinarySetup.DownloadEventyImage(from: photoURL) { [weak self] downloadedImage in
                if let image = downloadedImage {
                    self?.EventPhoto.image = image
                } else {
                    // If the image download fails, show a placeholder image
                    self?.EventPhoto.image = UIImage(systemName: "photo.fill")
                }
            }
        }
    }
}
