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
    static let userID = "05dsZ0SQ8CMTfrmoTHfyugMBbam2"
    
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
    
    static func deleteEvent(eventID: String, completion: @escaping (Bool, String?) -> Void) {
        ref.child("events").child(eventID).removeValue { error, _ in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
    
    static func updateEvent(eventID: String, updatedData: [String: Any], completion: @escaping (Bool, String?) -> Void) {
        // Update specific fields of the event in the database
        ref.child("events").child(eventID).updateChildValues(updatedData) { error, _ in
            if let error = error {
                // Print the error and return false
                print("Error updating event: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
            } else {
                // Event updated successfully
                print("Event updated successfully!")
                completion(true, nil)
            }
        }
    }
    
    
    // Function to save a review for an event
    static func saveReview(eventID: String, reviewText: String, stars: Int, completion: @escaping (Bool, String?) -> Void) {
        // Create a new review object
        let review = Review(reviewText: reviewText, stars: stars, userID: userID, eventID: eventID)
        
        // Push the review data to the Firebase database under the "reviews" node
        ref.child("reviews").child(eventID).childByAutoId().setValue(review.toDictionary()) { (error, _) in
            if let error = error {
                print("Error saving review: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
            } else {
                print("Review saved successfully!")
                completion(true, nil)
            }
        }
    }
    
    // Function to fetch reviews for a specific event
    static func getReviewsForEvent(eventID: String, completion: @escaping ([ReviewWithUser]) -> Void) {
        print("Starting to fetch reviews for event: \(eventID)")
        
        ref.child("reviews").child(eventID).observe(.value, with: { snapshot in
            var reviewsWithUser: [ReviewWithUser] = []
            var totalReviews = 0
            var processedReviews = 0
            
            print("Snapshot received for event: \(eventID), snapshot count: \(snapshot.childrenCount)")
            
            // Loop through the snapshot and decode the Review objects
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let reviewDict = snapshot.value as? [String: Any] {
                    
                    print("Processing review snapshot: \(snapshot.key)")
                    
                    // Decode Review data from Firebase
                    if let reviewText = reviewDict["reviewText"] as? String,
                       let stars = reviewDict["stars"] as? Int,
                       let userID = reviewDict["userID"] as? String {
                        
                        print("Decoded review for userID: \(userID), reviewText: \(reviewText), stars: \(stars)")
                        
                        // Increment the total review count
                        totalReviews += 1
                        
                        // Fetch user data for the given userID
                        print("Fetching user data for userID: \(userID)")
                        ref.child("users").child(userID).observeSingleEvent(of: .value, with: { userSnapshot in
                            if let userDict = userSnapshot.value as? [String: Any] {
                                let userName = userDict["name"] as? String ?? "Unknown"
                                let profileImageUrl = userDict["profileImageUrl"] as? String ?? ""
                                
                                print("User data fetched for userID: \(userID), userName: \(userName), profileImageUrl: \(profileImageUrl)")
                                
                                // Create a ReviewWithUser object
                                let reviewWithUser = ReviewWithUser(
                                    reviewText: reviewText,
                                    stars: stars,
                                    userID: userID,
                                    eventID: eventID,
                                    userName: userName,
                                    profileImageUrl: profileImageUrl
                                )
                                
                                // Add the review to the array
                                reviewsWithUser.append(reviewWithUser)
                            } else {
                                print("No user data found for userID: \(userID)")
                            }
                            
                            // Increment processed reviews
                            processedReviews += 1
                            print("Processed \(processedReviews) out of \(totalReviews) reviews")
                            
                            // Once all reviews are processed, call the completion handler
                            if processedReviews == totalReviews {
                                print("All reviews processed for event: \(eventID), calling completion handler")
                                completion(reviewsWithUser)
                            }
                        })
                    } else {
                        print("Failed to decode review data for snapshot: \(snapshot.key)")
                    }
                }
            }
            
            // If there are no reviews, immediately call the completion with an empty array
            if totalReviews == 0 {
                print("No reviews found for event: \(eventID), calling completion handler with empty array")
                completion(reviewsWithUser)
            }
        })
    }
    
    static func saveTicket(eventID: String, quantity: Int, price: Double, completion: @escaping (Bool, String?) -> Void) {
        // Create a ticket object with the provided details
        let ticketData: [String: Any] = [
            "quantity": quantity,
            "userID": userID,
            "price": price
        ]
        
        // Push the ticket data to the Firebase database under the "tickets" node for the specific event
        ref.child("tickets").child(eventID).child(userID).childByAutoId().setValue(ticketData) { error, _ in
            if let error = error {
                print("Error saving ticket: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
            } else {
                print("Ticket saved successfully!")
                completion(true, nil)
            }
        }
    }
    
    static func getTickets(completion: @escaping ([Ticket]) -> Void) {
        // Observe the "tickets" node to fetch all tickets for the given userID
        ref.child("tickets").observe(.value, with: { snapshot in
            var userTickets: [Ticket] = []
            
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let eventTickets = snapshot.value as? [String: Any] {
                    
                    // Iterate through the tickets for each event
                    for (eventID, ticketData) in eventTickets {
                        if let ticketDict = ticketData as? [String: Any] {
                            
                            // Check if the ticket belongs to the userID
                            if let ticketUserID = ticketDict["userID"] as? String, ticketUserID == self.userID {
                                
                                // Create a Ticket object from the ticket data
                                let ticket = Ticket(
                                    eventID: eventID,
                                    quantity: ticketDict["quantity"] as? Int ?? 0,
                                    userID: ticketUserID,
                                    price: ticketDict["price"] as? Double ?? 0.0
                                )
                                
                                // Add the ticket to the array
                                userTickets.append(ticket)
                            }
                        }
                    }
                }
            }
            
            // Once all tickets are processed, call the completion handler
            completion(userTickets)
        })
    }

    
}
