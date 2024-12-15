//
//  Firebase.swift
//  Glow_event
//
//  Created by BP-36-201-09 on 11/12/2024.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import Cloudinary

struct FirebaseDB {
    
    // Reference to Firebase Realtime Database
    static let ref = Database.database(url: "https://glowevent-9be31-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
    
    // Function to save event data to Firebase Realtime Database
    static func saveEventData(eventData: [String: Any], completion: @escaping (Bool, String?) -> Void) {
        // Push the event data into the "events" node
        ref.child("events").childByAutoId().setValue(eventData) { (error, reference) in
            if let error = error {
                // Print the error and return false
                print("Error saving event: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
            } else {
                // Event saved successfully
                print("Event saved successfully!")
                completion(true, nil)
            }
        
        }
    }
    
    // Static method to fetch all events from Firebase
    static func GetAllEvents(completion: @escaping ([Event]) -> Void) {
        ref.child("events").observe(.value, with: { snapshot in
            var fetchedEvents: [Event] = []
            
            // Loop through the snapshot and create Event objects
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                    let event = Event(snapshot: snapshot) // Assuming Event has a DataSnapshot initializer
                    fetchedEvents.append(event) // Add event to the array
                }
            }
            
            // Once data is fetched, call the completion handler
            completion(fetchedEvents)
        })
    }

        
}
    
