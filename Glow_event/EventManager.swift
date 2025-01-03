//
//  EventManager.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 28/12/2024.
//
import Foundation
import FirebaseFirestore
import UserNotifications

class EventManager {
    static let shared = EventManager()
    
    // Create an event and notify users based on their preferences
    func createEvent(title: String, category: String, startTime: Date,  completion: @escaping (Bool) -> Void) {
        let eventData: [String: Any] = [
            "title": title,
            "category": category,
            "startTime": Timestamp(date: startTime)
        ]
        
        Firestore.firestore().collection("events").addDocument(data: eventData) { error in
            if let error = error {
                print("Error creating event: \(error)")
                completion(false)
            } else {
                print("Event created successfully!")
                // Notify users based on their preferences
                self.notifyUsers(for: eventData, eventStartTime: startTime)
                completion(true)
            }
        }
    }
    
    // Notify users who are interested in the event category
    private func notifyUsers(for eventData: [String: Any], eventStartTime: Date) {
        let title = eventData["title"] as? String ?? "Glow Event"
        let category = eventData["category"] as? String ?? "General"
        
        Firestore.firestore().collection("users").whereField("userType", isEqualTo: "user1").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No users found.")
                return
            }
            
            for document in documents {
                let userId = document.documentID
                if let preferences = document.data()["preferences"] as? [String] {
                    print("User \(userId) preferences: \(preferences)")
                    if preferences.contains(category) {
                        // Send notification
                        print("Sending notification to user \(userId) for category \(category).")
                        self.sendNotification(to: userId, title: title, body: "Check out the new event: \(title)")
                        
                        NotificationManager.shared.scheduleLocalNotification(title: title, body: "Check out the new event: \(title)", date: eventStartTime, userId: userId)
                    } else {
                        print("User \(userId) does not have preference for category \(category).")
                    }
                } else {
                    print("User \(userId) has no preferences set.")
                }
            }
        }
    }
    
    // Save notifications 
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
    
    // Register for an event and schedule reminders
    func registerForEvent(eventId: String, userId: String,  completion: @escaping (Bool) -> Void) {
        
        let registrationData: [String: Any] = [
            "eventId": eventId,
            "userId": userId,
            "registeredAt": Timestamp(date: Date())
        ]
        
        Firestore.firestore().collection("userRegistration").addDocument(data: registrationData) { error in
            if let error = error {
                print("Error registering for event: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Registered for event successfully!")
                // Schedule reminders for registered events
                self.scheduleReminders(for: eventId, userId: userId)
                completion(true)
            }
        }
    }
    
    // Schedule reminders for registered events
    func scheduleReminders(for eventId: String, userId: String) {
        Firestore.firestore().collection("events").document(eventId).getDocument { document, error in
            guard let eventData = document?.data(), let startTime = (eventData["startTime"] as? Timestamp)?.dateValue() else {
                print("Error fetching event data: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
            let oneHourBefore = startTime.addingTimeInterval(-3600) // 1 hour before
            let twentyFourHoursBefore = startTime.addingTimeInterval(-86400) // 24 hours before
            
            let title = eventData["title"] as? String ?? "Event Reminder"
            let body = "Don't forget: The event is starting soon!"
            
            // Schedule 1 hour reminder
            NotificationManager.shared.scheduleLocalNotification(title: title, body: body, date: oneHourBefore, userId: userId)
            
            // Schedule 24 hours reminder
            NotificationManager.shared.scheduleLocalNotification(title: title, body: body, date: twentyFourHoursBefore, userId: userId)
        }
    }
}
