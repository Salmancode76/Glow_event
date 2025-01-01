//
//  NotificationManager.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 27/12/2024.
//
import Foundation
import UserNotifications
import UIKit

class NotificationManager {
    static let shared = NotificationManager()
    
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            } else {
                print("Notification authorization granted: \(granted)")
            }
        }
    }
    
    func scheduleLocalNotification(title: String, body: String, date: Date, userId: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        print("Scheduling notification: \(title) at \(date) for user: \(userId)")
        
        // Add the logo URL as an attachment
        if let logoURL = URL(string: "https://asset.cloudinary.com/doctomog7/9ec21fe2104eded7911300666e4c878b") {
            let attachment = try? UNNotificationAttachment(identifier: "logo", url: logoURL, options: nil)
            if let attachment = attachment {
                content.attachments = [attachment]
            }
        }
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(date) for user: \(userId).")
            }
        }
    }
    
}
