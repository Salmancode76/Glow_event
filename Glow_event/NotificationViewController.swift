//
//  NotificationViewController.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 27/12/2024.
//

import SwiftUI
import UIKit

class NotificationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var notifications: [AppNotification] {NotificationStore.shared.notifications} // Array to hold notifications

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Load notifications from the NotificationStore
        NotificationStore.shared.loadNotifications()
        tableView.reloadData()
        //loadNotifications() // Load notifications from your data source
    }
    
    // Load notifications (you can retrieve from NotificationStore or UserDefaults)
    /*private func loadNotifications() {
        notifications = NotificationStore.shared.notifications // Assuming you have a shared instance
        tableView.reloadData() // Reload the table view
    }*/
    
    // UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)
        let notification = notifications[indexPath.row]
        cell.textLabel?.text = notification.title
        cell.detailTextLabel?.text = notification.body
        return cell
    }
}
