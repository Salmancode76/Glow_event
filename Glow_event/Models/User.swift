import Foundation
import UIKit
import Firebase
import FirebaseDatabase

struct User {
    var name: String
    var email: String
    var username: String
    var gender: String
    var phone: String
    var profileImageUrl: String
    
    init(name: String, email: String, username: String, gender: String, phone: String, profileImageUrl: String) {
        self.name = name
        self.email = email
        self.username = username;
        self.gender = gender
        self.phone = phone
        self.profileImageUrl = profileImageUrl
    }
    
    init (snapshot: DataSnapshot) {
        let value = snapshot.value as? [String: Any] ?? [:]
        
        self.name = value["name"] as? String ?? "No Name"
        self.email = value["email"] as? String ?? "No Email"
        self.username = value["username"] as? String ?? "No username"
        self.gender = value["gender"] as? String ?? "No gender"
        self.phone = value["phone"] as? String ?? "No phone"
        self.profileImageUrl = value["profileImageUrl"] as? String ?? "No Profile Picture"
    }
}
