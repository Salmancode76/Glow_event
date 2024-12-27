//
//  EventOrganizer.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 22/12/2024.
//

import Foundation

class EventOrganizer: User {
    var name: String
    var email: String
    var websiteurl: String
    var phone: String
    
    override var description: String {
        return """
            - Event Organizer -
            \(super.description)
            - Event Organizer Information -
            Name: \(name)
            Email: \(email)
            Website URL: \(websiteurl)
            Phone: \(phone)
        """
    }
    
    init(name: String, email: String, websiteurl: String, phone: String, username: String, password: String) {
        self.name = name
        self.email = email
        self.websiteurl = websiteurl
        self.phone = phone
        super.init(username: username, password: password, userType: .eventOrganizer)
    }
    
    /*override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EOCodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(websiteurl, forKey: .websiteurl)
        try container.encode(phone, forKey: .phone)
        try super.encode(to: encoder)
    }
    
    //this initializer decodes the object
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: EOCodingKeys.self)
        self.name = try values.decodeIfPresent(String.self, forKey: .name)!
        self.email = try values.decodeIfPresent(String.self, forKey: .email)!
        self.websiteurl = try values.decodeIfPresent(String.self, forKey: .websiteurl)!
        self.phone = try values.decodeIfPresent(String.self, forKey: .phone)!
        //decode base class
        try super.init(from: decoder)
    }*/
}
