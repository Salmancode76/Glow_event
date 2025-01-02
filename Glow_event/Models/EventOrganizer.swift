import Foundation
import UIKit
import Firebase
import FirebaseDatabase

struct EventOrganizer {
    var name: String
    var email: String
    var username: String
    var phone: String
    var profileImageUrl: String
    var website: String

    init(name: String, email: String, username: String, phone: String, profileImageUrl: String, website: String) {
        self.name = name
        self.email = email
        self.username = username
        self.phone = phone
        self.profileImageUrl = profileImageUrl
        self.website = website
    }
    
    init(snapshot: DataSnapshot) {
        let value = snapshot.value as? [String: Any] ?? [:]
        
        self.name = value["name"] as? String ?? "No Name"
        self.email = value["email"] as? String ?? "No Email"
        self.username = value["username"] as? String ?? "No Username"
        self.phone = value["phone"] as? String ?? "No Phone"
        self.profileImageUrl = value["profileImageUrl"] as? String ?? "No Profile Picture"
        self.website = value["website"] as? String ?? "No Website"
    }
}
