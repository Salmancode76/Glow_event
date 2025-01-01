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
    
    init(name: String, email: String, websiteurl: String, phone: String, uid: String, username: String, password: String) {
        self.name = name
        self.email = email
        self.websiteurl = websiteurl
        self.phone = phone
        super.init(uid: uid, username: username, password: password, userType: .eventOrganizer)
    }
    
}
