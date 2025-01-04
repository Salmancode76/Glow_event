//
//  Event Organizer.swift
//  Glow_event
//
//  Created by PRINTANICA on 04/01/2025.
//

import Foundation
struct EventOrganizer {
    let id: String
    let email: String
    let logo: String
    let name: String
    let phone: String
    let username: String
    let websiteURL: String
    
    init?(id: String, data: [String: Any]) {
        guard let email = data["email1"] as? String,
              let highlights = data["highlights"] as? [String: Any],
              let logo = highlights["logo"] as? String,
              let name = highlights["name"] as? String,
              let phone = highlights["phone"] as? String,
              let username = highlights["username"] as? String,
              let websiteURL = highlights["website url"] as? String else {
            return nil
        }
        
        self.id = id
        self.email = email
        self.logo = logo
        self.name = name
        self.phone = phone
        self.username = username
        self.websiteURL = websiteURL
    }
}
