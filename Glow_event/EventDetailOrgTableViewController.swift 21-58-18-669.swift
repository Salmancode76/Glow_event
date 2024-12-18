import UIKit

class EventDetailOrgTableViewController: UITableViewController {

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
    var eventlocation :String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set up the UI components with event data passed from the previous view controller
        EventLocation.text = eventlocation
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // We only have one section
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Only one row to display the event's details
        return 2
    }

    // This is the method for setting up the cell content, but we aren't using it in this case
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventDetailCell", for: indexPath)
        
        // You could configure the cell here if necessary, but we are populating the details directly in the labels above
        return cell
    }
}
