//
//  enums.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 22/12/2024.
//

import Foundation

enum Gender: String, CaseIterable {
    case male = "Male", female = "Female"
}

enum UserType {
    case user1, eventOrganizer, admin
}
