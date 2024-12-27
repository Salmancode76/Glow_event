//
//  AppNotification.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 27/12/2024.
//

import Foundation

struct AppNotification: Identifiable, Codable {
    var id = UUID()
    var title: String
    var body: String
    var timestamp: Date
}
