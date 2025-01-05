//
//  RegistrationViewController.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 28/12/2024.
//
import UIKit
import Foundation
import FirebaseFirestore
import FirebaseAuth

class RegisterationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        tableView.backgroundColor = .black
        
        tableView.reloadData()
        setupTableView()
        fetchEvents()
        NotificationManager.shared.requestAuthorization() // Request notification permissions
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register the cell class
        tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "EventCell")
        
        // Set up Auto Layout
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func fetchEvents() {
        let db = Firestore.firestore()
            db.collection("events").getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching events: \(error.localizedDescription)")
                    return
                }

                self.events = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    guard let title = data["title"] as? String,
                          let category = data["category"] as? String,
                          let startDate = data["startTime"] as? Timestamp else {
                        print("Skipping document due to missing fields: \(data)")
                        return nil
                    }
                    return Event(id: doc.documentID, title: title, category: category, startDate: startDate)
                } ?? []

                DispatchQueue.main.async {
                    self.tableView.reloadData() // Reload table view with fetched events
                }
        }
    }
    
    // MARK: - Register For Events
    
    func register(eventId: String){
        guard let userId = GlobalUser.shared.currentUser?.uid else {
            showAlert(message: "Error: Unable to register for event (missing user ID).")
            return
        }
        
        print("Attempting to register for event with ID: \(eventId) and User ID: \(userId)")
        
        guard !eventId.isEmpty else {
            print("Error: eventId is empty")
            return
        }
        
        Firestore.firestore().collection("events").document(eventId).getDocument { document, error in
            guard let eventData = document?.data(), let startTime = (eventData["startTime"] as? Timestamp)?.dateValue() else {
                print("Error fetching event data: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
            self.saveRegistration(userId: userId, eventId: eventId) {
                self.scheduleNotifications(for: eventData, startTime: startTime, userId: userId)
            }
        }
    }
    
    private func saveRegistration(userId: String, eventId: String, completion: @escaping () -> Void) {
            let registrationData: [String: Any] = [
                "userId": userId,
                "eventId": eventId,
                "registrationTime": Timestamp(date: Date())
            ]

            Firestore.firestore().collection("userRegistration").addDocument(data: registrationData) { error in
                if let error = error {
                    print("Error saving registration: \(error.localizedDescription)")
                    self.showAlert(message: "Error saving registration.")
                } else {
                    self.showAlert(message: "You have registered for the event!")
                    completion() // Call completion to schedule notifications
                }
            }
        }
    
    
    // MARK: - Schedule Notifications
    
    private func scheduleNotifications(for eventData: [String: Any], startTime: Date, userId: String) {
            let title = eventData["title"] as? String ?? "Event Reminder"
            var body = "Don't forget: The event is starting soon!"

            // Schedule notifications
            let oneHourBefore = startTime.addingTimeInterval(-3600) // 1 hour before
            let twentyFourHoursBefore = startTime.addingTimeInterval(-86400) // 24 hours before

            if oneHourBefore > Date() {
                //schedule a reminder
                body = "Don't forget: The event is starting after 1 hour"
                NotificationManager.shared.scheduleLocalNotification(title: title, body: body, date: oneHourBefore, userId: userId)
                //save reminders to firebase
                sendNotification(to: userId, title: title, body: body)
            }
            
            if twentyFourHoursBefore > Date() {
                //schedule a reminder
                body = "Don't forget: The event is starting after 24 hours"
                NotificationManager.shared.scheduleLocalNotification(title: title, body: body, date: twentyFourHoursBefore, userId: userId)
                //save reminders to firebase
                sendNotification(to: userId, title: title, body: body)
            }
        }
    
    // MARK: - SAVE Reminders
    
    private func sendNotification(to userId: String, title: String, body: String) {
        let notificationData: [String: Any] = [
            "title": title,
            "body": body,
            "timestamp": Timestamp(date: Date())
        ]
        
        Firestore.firestore().collection("notifications").document(userId).collection("userNotifications").addDocument(data: notificationData) { error in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
            } else {
                print("Notification sent successfully to user: \(userId)")
            }
        }
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
        let event = events[indexPath.row]
            cell.textLabel?.text = event.title // Title
            cell.detailTextLabel?.text = event.category // Category
        print("Configuring cell for event: \(event.title)")
            return cell
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEvent = events[indexPath.row] // Assuming events is an array of Event objects
            let eventId = selectedEvent.id // Access the event ID correctly

        //guard let userId = GlobalUser.shared.getCurrentUserId() else {
          //      showAlert(message: "Error: Unable to register for event (missing event ID or user ID).")
            //    return
            //}
            print("Selected event ID: \(eventId)")
            // Proceed to register for the event
            register(eventId: eventId)

            // This alert should be shown only if registration was successful
            //showAlert(message: "You have registered for the event!")
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
