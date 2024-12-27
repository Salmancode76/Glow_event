//
//  NotificationManager.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 27/12/2024.
//

import Foundation
import UIKit
import UserNotifications
import SwiftUI


class NotificationManager {
    static let shared = NotificationManager()
    var notificationStore = NotificationStore()

    private init() {
        requestNotificationPermission()
    }

    private func requestNotificationPermission() {
           let center = UNUserNotificationCenter.current()
           center.requestAuthorization(options: [.alert, .sound]) { granted, error in
               if let error = error {
                   print("Error requesting notification permission: \(error)")
               }
           }
       }
    
   
    
    func sendNotification(for event: Event, username: String) {
        let content = UNMutableNotificationContent()
        content.title = "New Event: \(event.title)"
        content.body = "\(username), there's a new event in your preferred category: \(event.category)"
        content.sound = .default

        // Save to notification store
        let appNotification = AppNotification(title: content.title,
                                             body: content.body,
                                             timestamp: Date())
        notificationStore.addNotification(appNotification)

        // Trigger notification immediately
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print("Error adding notification: \(error)")
            }
        }
    }
}
