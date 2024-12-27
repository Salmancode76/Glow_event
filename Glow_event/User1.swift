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
    
    init(firstName: String, lastName: String, age: Int, phone: String, gender: Gender, username: String, password: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.phone = phone
        self.gender = gender
        super.init(username: username, password: password, userType: .user1)
    }
    
    /*override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: UCodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(age, forKey: .age)
        try container.encode(email, forKey: .email)
        try container.encode(phone, forKey: .phone)
        try container.encode(gender, forKey: .gender)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: UCodingKeys.self)
        self.firstName = try values.decodeIfPresent(String.self, forKey: .firstName)!
        self.lastName = try values.decodeIfPresent(String.self, forKey: .lastName)!
        self.age = try values.decodeIfPresent(Int.self, forKey: .age)!
        self.email = try values.decodeIfPresent(String.self, forKey: .email)!
        self.phone = try values.decodeIfPresent(String.self, forKey: .phone)!
        self.gender = try values.decodeIfPresent(Gender.self, forKey: .gender)!
        //decode the base
        try super.init(from: decoder)
    }*/
}
