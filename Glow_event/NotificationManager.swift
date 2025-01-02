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
        
        
        // Add the logo URL as an attachment
        if let logoURL = URL(string: "https://res.cloudinary.com/doctomog7/image/upload/v1735740154/PHOTO-2025-01-01-15-43-11_esiyqm.jpg") {
            downloadImage(from: logoURL) { localURL in
                if let localURL = localURL {
                    do {
                        let attachment = try UNNotificationAttachment(identifier: "logo", url: logoURL, options: nil)
                        content.attachments = [attachment]
                    } catch {
                        print("Error creating attachment: \(error.localizedDescription)")
                    }
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
    
    func downloadImage(from url: URL, completion: @escaping (URL?) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { tempURL, response, error in
            guard let tempURL = tempURL, error == nil else {
                completion(nil)
                return
            }

            // Get the documents directory
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let localURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)

            do {
                // Move the downloaded file to the documents directory
                try FileManager.default.moveItem(at: tempURL, to: localURL)
                completion(localURL)
            } catch {
                print("Error saving file: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
    
}
