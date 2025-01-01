//
//  Reminder Manager.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 01/01/2025.
//

import Foundation
import FirebaseFirestore

class ReminderManager {
    static let shared = ReminderManager()
    
    private init() {}
    
    func checkForUpcomingEvents() {
        let db = Firestore.firestore()
        db.collection("userRegistrations").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching registrations: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            for document in documents {
                let userId = document.data()["userId"] as? String ?? ""
                let eventId = document.data()["eventId"] as? String ?? ""
                
                self.checkEventStartDate(eventId: eventId, userId: userId)
            }
        }
    }
    
    private func checkEventStartDate(eventId: String, userId: String) {
        let db = Firestore.firestore()
        db.collection("events").document(eventId).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching event: \(error.localizedDescription)")
                return
            }
            
            guard let eventData = snapshot?.data(),
                  let startDate = eventData["startDate"] as? Timestamp else { return }
            
            let currentDate = Date()
            let oneHourBefore = startDate.dateValue().addingTimeInterval(-3600) // 1 hour before
            let twentyFourHoursBefore = startDate.dateValue().addingTimeInterval(-86400) // 24 hours before
            
            if currentDate >= twentyFourHoursBefore && currentDate < startDate.dateValue() {
                self.sendReminder(to: userId, eventTitle: eventData["title"] as? String ?? "Event")
            } else if currentDate >= oneHourBefore && currentDate < startDate.dateValue() {
                self.sendReminder(to: userId, eventTitle: eventData["title"] as? String ?? "Event")
            }
        }
    }
    
    private func sendReminder(to userId: String, eventTitle: String) {
        let reminderData: [String: Any] = [
            "title": "Upcoming Event Reminder",
            "body": "Your event '\(eventTitle)' is starting soon!",
            "timestamp": Timestamp(date: Date())
        ]
        
        let db = Firestore.firestore()
        db.collection("notifications").document(userId).collection("userNotifications").addDocument(data: reminderData) { error in
            if let error = error {
                print("Error sending reminder: \(error.localizedDescription)")
            } else {
                print("Reminder sent successfully to user: \(userId)")
            }
        }
    }
}
