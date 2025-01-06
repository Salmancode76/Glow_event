//
//  EventTableViewCell.swift
//  Glow_event
//
//  Created by Natheer on 06/01/2025.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var organizerLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    
    private var currentImageURL: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(event: Event) {
        // Organizing event data
        organizerLabel.text = "Organizer: Not Listed"
        categoryLabel.text = "Category: \(event.EventCategory ?? "Concert")"
        
        // Format start and end date
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateFormat = "EEE, MMM d • h:mm a" // "Fri, Nov 20 • 6:00 PM"
        let startDateFormatted = startDateFormatter.string(from: event.startDate)
        
        let endTimeFormatter = DateFormatter()
        endTimeFormatter.dateFormat = "h:mm a" // "10:00 PM"
        let endTimeFormatted = endTimeFormatter.string(from: event.endDate)
        
        dateLabel.text = "\(startDateFormatted) - \(endTimeFormatted)"
        
        // Price information
        priceLabel.text = "Price: \(event.price) BD"
        
        // Event name
        nameLabel.text = event.EventName
        
        // Loading the image from URL asynchronously
        if let imageURL = URL(string: event.EventPhotoURL) {
            currentImageURL = imageURL
            loadImage(from: imageURL)
        }
    }
    
    private func loadImage(from url: URL) {
            // Example: Asynchronously loading an image
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        // Only set the image if the cell is still the same
                        if self.currentImageURL == url {
                            self.eventImageView.image = image
                        }
                    }
                }
            }
        }
}
