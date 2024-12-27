//
//  AppData.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 22/12/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class AppData {
    static var admin: [User] = [User(username: "admin11@gmail.com", password: "adminglowevent", userType: .admin)]
    static var eventOrganizers: [EventOrganizer] = []
    static var appUsers: [User] = []
    
    static func wipe() {
        admin = []
        eventOrganizers = []
        appUsers = []
    }
    
    //Functions to Manage Users
    
    static func getUser(username: String) -> User? {
        let allUsers: [User] = admin + eventOrganizers + appUsers
        return allUsers.first(where: { $0.username == username })
    }
    
    static func getUser(uid: UUID) -> User? {
        let allUsers: [User] = admin + eventOrganizers + appUsers
        return allUsers.first(where: { $0.uid == uid })
    }
    
    static func addUser(user: User) {
        if user is EventOrganizer {
            eventOrganizers.append(user as! EventOrganizer)
        }
        else if user is User1 {
            appUsers.append(user as! User1)
        }
        else {
            admin.append(user)
        }
        
    }
    
    func saveData() {
        
    }
    
    //return user if email exists, used for registering a new user
    static func getUserByEmail(email: String) -> User? {
        let allUsers: [User] = AppData.admin + AppData.eventOrganizers + AppData.appUsers
        let matchingUsers: [User] = allUsers.filter{ $0.username == email }
        if (matchingUsers.count > 0) {
            return matchingUsers[0]
        }
        return nil
    }
}
