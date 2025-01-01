//
//  UserHomeViewController.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 26/12/2024.
//

import SwiftUI
import FirebaseFirestore

class UserHomeViewController: UIViewController, UNUserNotificationCenterDelegate  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.requestNotificationPermissions()
        
        // Set the notification center delegate
        UNUserNotificationCenter.current().delegate = self
    }
    
    private func requestNotificationPermissions() {
        // Create the notification center
        let center = UNUserNotificationCenter.current()
        
        // Request authorization for alerts, sounds, and badges
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error.localizedDescription)")
                return
            }
            else if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    willPresent notification: UNNotification,
                                    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.alert, .sound]) // Show alert and play sound
        }
}
    
