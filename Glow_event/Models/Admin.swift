import Foundation
import UIKit
import Firebase
import FirebaseDatabase

struct Admin {
    var email: String
    var id: Int
    var username: String
    var name: String
    var profileImageUrl: String
    
    init(name: String, email: String, username: String, id: Int, profileImageUrl: String) {
        self.name = name
        self.email = email
        self.username = username
        self.id = id
        self.profileImageUrl = profileImageUrl
    }
    
    init(snapshot: DataSnapshot) {
        let value = snapshot.value as? [String: Any] ?? [:]
        
        self.name = value["name"] as? String ?? "No Name"
        self.email = value["email"] as? String ?? "No Email"
        self.username = value["username"] as? String ?? "No Username"
        self.id = value["id"] as? Int ?? 0
        self.profileImageUrl = value["profileImageUrl"] as? String ?? "No Profile Picture"
    }
}
