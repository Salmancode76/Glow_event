//
//  NotificationViewController.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 27/12/2024.
//

import SwiftUI
import UIKit
import UserNotifications
import FirebaseFirestore
import FirebaseAuth

class NotificationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var notifications: [AppNotification] = [] // Array to hold notification messages

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.dataSource = self
        //tableView.delegate = self
        
        // Setup table view layout
        //tableView.frame = view.bounds
        //view.addSubview(tableView)
        
        setupTableView()
        setupTableViewConstraints()
        fetchNotifications()
    }
    
    private func setupTableViewConstraints() {
           NSLayoutConstraint.activate([
               tableView.topAnchor.constraint(equalTo: view.topAnchor),
               tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
           ])
       }

    
    func setupTableView() {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(NotificationCell.self, forCellReuseIdentifier: "NotificationCell")
            tableView.translatesAutoresizingMaskIntoConstraints = false

        // Setup table view layout
            tableView.frame = view.bounds
            view.addSubview(tableView)
        }
    
    // Fetch notifications for the logged-in user
    func fetchNotifications() {
            guard let userId = Auth.auth().currentUser?.uid else {
                print("User  is not logged in.")
                return
            }
    
            let db = Firestore.firestore()
            db.collection("notifications").document(userId).collection("userNotifications").order(by: "timestamp", descending: true).getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching notifications: \(error.localizedDescription)")
                    return
                }
    
                self.notifications = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    guard let title = data["title"] as? String,
                          let body = data["body"] as? String,
                          let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() else {
                        print("Skipping document due to missing fields: \(data)")
                        return nil // Skip this document if any field is missing
                    }
                    return AppNotification(title: title, body: body, timestamp: timestamp)
                } ?? []
    
                self.tableView.reloadData() // Reload table view with fetched notifications
            }
        }
    
        // MARK: - UITableViewDataSource Methods
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return notifications.count
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
            let notification = notifications[indexPath.row]
    
            cell.titleLabel.text = notification.title
            cell.detailLabel.text = notification.body
                
            // Create a DateFormatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short

            // Format the timestamp (you can customize the format)
            cell.timestampLabel.text = dateFormatter.string(from: notification.timestamp)
            
            // Reset image view before loading
            cell.logoImageView.image = nil
            
            // Set the logo image
            if let logoURL = URL(string: "https://asset.cloudinary.com/doctomog7/9ec21fe2104eded7911300666e4c878b") {
                    URLSession.shared.dataTask(with: logoURL) { data, response, error in
                        if let error = error {
                            print("Error fetching image: \(error.localizedDescription)")
                            return
                        }
                        guard let data = data, let image = UIImage(data: data) else {
                            print("Error converting data to image")
                            return
                        }

                        DispatchQueue.main.async {
                            // Only set the image if the cell is still visible
                            if let currentCell = tableView.cellForRow(at: indexPath) as? NotificationCell {
                                currentCell.logoImageView.image = image
                            }
                        }
                    }.resume()
            }
            return cell
        }
    }
    
    
