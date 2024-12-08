import UIKit
import Firebase
import FirebaseDatabase

class HomeOrgViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var EventsOrgTable: UITableView!
    
    @IBOutlet weak var EvnentsOrgTable: UITableView!
    var events: [Event] = [] // Array to hold Event objects
 

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set data source and delegate for the table view
        EventsOrgTable.dataSource = self
        EventsOrgTable.delegate = self
        
        self.EvnentsOrgTable.backgroundColor = .black
        self.EvnentsOrgTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

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
       
        
        // Dequeue the cell with the identifier "event"
        let event = events[indexPath.row]

         
        let cell = tableView.dequeueReusableCell(withIdentifier: "event", for: indexPath) as! EventOrgTableViewCell
        // Customize cell appearance (black background and white text)
             cell.textLabel?.textColor = .white // Set text color to white
             cell.detailTextLabel?.textColor = .white // Set detail text color to white
             cell.backgroundColor = .black // Set cell background color to black
             
      
        // Set the cell text
        //cell.textLabel?.text = event.EventName
     
        
        cell.detailTextLabel?.textColor = .white // Set detail text color to white
      //  cell.backgroundColor = .black // Set cell background color to black
        let selectedView = UIView()
        selectedView.backgroundColor = .darkGray // You can set any color for selection
        cell.selectedBackgroundView = selectedView
        cell.EventName.textColor = .white
        //cell.EventStartDate.textColor = .white
        // Create the UIImage from the system name (returns UIImage?)
           if let photoImage = UIImage(systemName: "photo.fill") {
               // Safely unwrap the UIImage and pass it to the setupCell method
               cell.setupCell(photo: photoImage,name: event.EventName,startDate: event.startDate, venu: event.venu_options)
           }
    
        
        cell.textLabel?.textColor = .white // Set text color to white
        cell.detailTextLabel?.textColor = .white // Set detail text color to white
        cell.backgroundColor = .black // Set cell background color to black
        // Step 1: Construct the full image URL

        
        // Step 1: Construct the full image URL (Cloudinary URL)
         let cloudinaryBaseURL = "https://res.cloudinary.com/doctomog7/image/upload/"
         let imagePath = event.EventPhotoURL // e.g., "event/images/2B84E488-B6BE-45BA-975F-F65AF2597EC2"
         let fullImageURL = cloudinaryBaseURL + imagePath

         // Step 2: Load the image asynchronously using URLSession
         if let imageURL = URL(string: fullImageURL) {
             // Set a placeholder image while the image is loading
             cell.EventImage.image = UIImage(systemName: "photo.fill") // Placeholder image
             
             let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
                 if let data = data, error == nil {
                     DispatchQueue.main.async {
                         // Set the image to the UIImageView once downloaded
                         cell.EventImage.image = UIImage(data: data)
                     }
                 } else {
                     print("Failed to download image from Cloudinary: \(String(describing: error))")
                 }
             }
             task.resume() // Start the download task
         }


        return cell
    }
}

