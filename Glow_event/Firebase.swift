//
//  Firebase.swift
//  Glow_event
//
//  Created by PRINTANICA on 02/01/2025.
//

import Foundation
import Firebase



func fetchEvents(completion: @escaping ([Event]) -> Void) {
    let db = Firestore.firestore()
    db.collection("events").getDocuments { (snapshot, error) in
        var events: [Event] = []
        if let error = error {
            print("Error fetching events: \(error)")
            completion(events)
            return
        }
        for document in snapshot!.documents {
            let data = document.data()
            if let name = data["name"] as? String,
               let startDate = data["startDate"] as? String,
               let location = data["location"] as? String,
               let imageUrl = data["imageUrl"] as? String {
                let event = Event(startDate: startDate, name: name, location: location, imageURL: imageUrl)
                events.append(event)
            }
        }
        completion(events)
    }
}
