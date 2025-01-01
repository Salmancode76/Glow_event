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
    case user1
    case eventOrganizer
    case admin

    // Method to convert a string to UserType
    static func fromString(_ type: String) -> UserType? {
        switch type {
        case "user1":
            return .user1
        case "eventOrganizer":
            return .eventOrganizer
        case "admin":
            return .admin
        default:
            return nil
        }
    }
}

