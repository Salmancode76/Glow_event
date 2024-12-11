import Foundation
import UIKit
import Firebase
import FirebaseDatabase

struct Event {
    var EventName: String
    var venu_options: String
    var price: Double
    var startDate: Date
    var endDate: Date
    var descrip: String
    var EventStatus: String
    var EventPhotoURL: String  // Store image URL as a String (not UIImage)
    
    // Custom initializer that accepts all necessary parameters
    init(EventName: String, venu_options: String, price: Double, startDate: Date, endDate: Date, descrip: String, EventStatus: String, EventPhotoURL: String) {
        self.EventName = EventName
        self.venu_options = venu_options
        self.price = price
        self.startDate = startDate
        self.endDate = endDate
        self.descrip = descrip
        self.EventStatus = EventStatus
        self.EventPhotoURL = EventPhotoURL
    }
    
    // Alternatively, this can be used if you're still fetching from Firebase DataSnapshot:
    init(snapshot: DataSnapshot) {
        let value = snapshot.value as? [String: Any] ?? [:]
        
        self.EventName = value["EventName"] as? String ?? "No Name"
        self.venu_options = value["venue_options"] as? String ?? "No Venue"
        self.price = value["price"] as? Double ?? 0.0
        self.descrip = value["description"] as? String ?? "No Description"
        self.EventStatus = value["EventStatus"] as? String ?? "No Status"
        self.EventPhotoURL = value["EventImg"] as? String ?? ""
        
        let startTimestamp = value["startDate"] as? Double ?? 0
        let endTimestamp = value["endDate"] as? Double ?? 0
        self.startDate = Date(timeIntervalSince1970: startTimestamp)
        self.endDate = Date(timeIntervalSince1970: endTimestamp)
    }
}