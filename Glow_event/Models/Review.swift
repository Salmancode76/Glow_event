//
//  Review.swift
//  Glow_event
//
//  Created by a-awadhi on 05/01/2025.
//


public struct Review {
    var reviewText: String
    var stars: Int
    var userID: String
    var eventID: String

    // Initializer to create a Review
    init(reviewText: String, stars: Int, userID: String, eventID: String) {
        self.reviewText = reviewText
        self.stars = stars
        self.userID = userID
        self.eventID = eventID
    }

    // Method to convert the Review to a dictionary for Firebase
    func toDictionary() -> [String: Any] {
        return [
            "reviewText": reviewText,
            "stars": stars,
            "userID": userID,
            "eventID": eventID
        ]
    }
}

public struct ReviewWithUser {
    var reviewText: String
    var stars: Int
    var userID: String
    var eventID: String
    var userName: String
    var profileImageUrl: String
}
