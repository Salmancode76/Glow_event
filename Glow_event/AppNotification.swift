//
//  AppNotification.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 27/12/2024.
//

import Foundation

struct AppNotification {
    var title: String
    var body: String
    var timestamp: Date
    
    
    init(title: String, body: String, timestamp: Date) {
        self.title = title
        self.body = body
        self.timestamp = timestamp
    }
}
