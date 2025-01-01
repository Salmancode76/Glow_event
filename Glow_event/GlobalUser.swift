//
//  GlobalUser.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 31/12/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class GlobalUser {
    static let shared = GlobalUser()
    
    private init() {}
    
    var currentUser: User?
    var currentUserType: UserType?
    
    func getCurrentUserId() -> String? {
            return Auth.auth().currentUser?.uid
        }
    
    
    func isUserLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    func fetchCurrentUser (completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        
        print("Fetching user data for ID: \(userId)")
        
        Firestore.firestore().collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                let username = data?["username"] as? String ?? ""
                let password = data?["password"] as? String ?? ""
                let userTypeString = data?["userType"] as? String ?? "unknown"
                let userType = UserType.fromString(userTypeString) ?? .user1
                let preferences = data?["preferences"] as? [String] ?? []
                self.currentUserType = userType
                
                if userType == .user1 {
                     // Retrieve additional fields for User1
                    let firstName = data?["firstName"] as? String ?? ""
                    let lastName = data?["lastName"] as? String ?? ""
                    let age = data?["age"] as? Int ?? 0
                    let phone = data?["phone"] as? String ?? ""
                    let genderString = data?["gender"] as? String ?? "male" // Default to male
                    let gender = Gender(rawValue: genderString) ?? .male // Convert to Gender enum
                    
                    // Initialize User1 with actual data
                    self.currentUser = User1(firstName: firstName, lastName: lastName, age: age, phone: phone, gender: gender, uid: self.currentUser!.uid, username: username, password: password, preferences: preferences)
                    } else {
                    // Initialize User with basic data
                        self.currentUser = User(uid: self.currentUser!.uid, username: username, password: password, userType: userType)
                    }
                completion(true)
            } else {
                print("User  does not exist or error fetching user: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
            }
        }
    }
}
