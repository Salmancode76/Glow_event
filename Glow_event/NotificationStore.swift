//
//  NotificationStore.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 27/12/2024.
//

import Foundation

class NotificationStore: ObservableObject {
    static let shared = NotificationStore() // Singleton instance
    
    @Published var notifications: [AppNotification] = []
    
    init() {
        loadNotifications()
    }
    
    func addNotification(_ notification: AppNotification) {
        notifications.append(notification)
        saveNotifications()
    }
    
    private func saveNotifications() {
        // Save to UserDefaults or another storage solution
        // Convert notifications to Data and store
        if let encoded = try? JSONEncoder().encode(notifications) {
            UserDefaults.standard.set(encoded, forKey: "notifications")
        }
    }
    
    func loadNotifications() {
        // Load from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "notifications"),
           let savedNotifications = try? JSONDecoder().decode([AppNotification].self, from: data) {
            notifications = savedNotifications
        }
    }
}
