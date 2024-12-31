import UIKit
import Firebase
import FirebaseDatabase

class AdminHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var events: [Event] = [] // To store the fetched events

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        fetchEvents()
    }

    // MARK: - Table View Setup
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Fetch Events
    private func fetchEvents() {
        let databaseRef = Database.database().reference().child("events")
        databaseRef.observe(.value) { snapshot in
            var fetchedEvents: [Event] = []

            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    let event = Event(snapshot: childSnapshot)
                    fetchedEvents.append(event)
                }
            }

            self.events = fetchedEvents
            self.tableView.reloadData()
        }
    }

    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdminEventCell", for: indexPath) as? EventOrgTableViewCell else {
            return UITableViewCell()
        }

        let event = events[indexPath.row]

        // Load the event image
        if let imageUrl = URL(string: event.EventPhotoURL) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageUrl) {
                    DispatchQueue.main.async {
                        cell.EventImage.image = UIImage(data: data)
                    }
                }
            }
        } else {
            cell.EventImage.image = UIImage(systemName: "photo")
        }

        // Setup the rest of the cell
        cell.EventName.text = event.EventName
        cell.Eventvenu.text = event.venu_options

        // Format the start date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d • h:mm a"
        cell.EventStartDate.text = dateFormatter.string(from: event.startDate)

        return cell
    }

    // MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEvent = events[indexPath.row]
        showEventDetails(event: selectedEvent)
    }

    private func showEventDetails(event: Event) {
        print("Selected Event: \(event.EventName)")
        // Navigate to event detail page for admin-specific actions
    }
}
