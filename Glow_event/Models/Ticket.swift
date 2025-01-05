//
//  Ticket.swift
//  Glow_event
//
//  Created by a-awadhi on 05/01/2025.
//

public struct Ticket {
    let eventID: String
    let quantity: Int
    let userID: String
    let price: Double
    
    // Initialize from a dictionary
    init(eventID: String, quantity: Int, userID: String, price: Double) {
        self.eventID = eventID
        self.quantity = quantity
        self.userID = userID
        self.price = price
    }
}
