//
//  NotificationManager.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 27/12/2024.
//
import Foundation
import UserNotifications
import UIKit

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    let notificationCenter = UNUserNotificationCenter.current()
    
    override init()
    {
        super.init()
        notificationCenter.delegate = self
    }
    
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
    
    //Delegate function
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.sound, .banner]
    }
    
    func scheduleLocalNotification(title: String, body: String, date: Date, userId: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        print("Scheduling notification: \(title) at \(date) for user: \(userId)")
                        
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
