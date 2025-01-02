//
//  EventTableViewCell.swift
//  Glow_event
//
//  Created by PRINTANICA on 02/01/2025.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var startDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(with event: Event) {
        eventName.text = event.name
        startDate.text = event.startDate
        eventLocation.text = event.location
        
        if let url = URL(string: event.imageURL) {
            loadImage(from: url)
        } else {
            eventImage.image = UIImage(named: "placeholder")
        }
        
        
    }
        private func loadImage(from url: URL) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.eventImage.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        self.eventImage.image = UIImage(named: "placeholder")
                    }
                    
                }
                
            }
        }}
