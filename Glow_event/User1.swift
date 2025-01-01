//
//  User1.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 22/12/2024.
//

import Foundation

class User1: User {
    var firstName: String
    var lastName: String
    var name: String {
        return "\(firstName) \(lastName)"
    }
    var preferences: [String]
    
    var age: Int
    //var email: String
    var phone: String
    var gender: Gender
    
    override var description: String {
        return """
            - App Users -
            \(super.description)
            - App Users Information -
            Name: \(name)
            Age: \(age)
            Phone: \(phone)
            Gender: \(gender)
        """
    }
    
    init(firstName: String, lastName: String, age: Int, phone: String, gender: Gender, uid: String, username: String, password: String, preferences: [String]) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.phone = phone
        self.gender = gender
        self.preferences = preferences
        super.init(uid: uid, username: username, password: password, userType: .user1)
    }
    
}
