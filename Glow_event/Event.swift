import Foundation
import FirebaseFirestore

struct Event {
    let id: String
    let title: String
    let category: String
    let startDate: Timestamp
    
    init(id: String, title: String, category: String, startDate: Timestamp) {
        self.id = id
        self.title = title
        self.category = category
        self.startDate = startDate
    }
        
    // Custom initializer for Firestore documents
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let title = data["title"] as? String,
              let category = data["category"] as? String,
              let startDate = data["startDate"] as? Timestamp
        else {
            return nil
        }
        
        self.id = document.documentID
        self.title = title
        self.category = category
        self.startDate = startDate
    }
}
