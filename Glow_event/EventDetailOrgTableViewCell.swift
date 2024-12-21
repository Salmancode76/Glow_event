//
//  EventDetailOrgTableViewCell.swift
//  Glow_event
//
//  Created by BP-36-201-09 on 20/12/2024.
//

import UIKit

class EventDetailOrgTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .black
        
        EventName.textColor = .white
           EventStatus.textColor = .white
           EventDate.textColor = .white
           EventSeatslbl.textColor = .white
           EventDesclbl.textColor = .white
           Pricelbl.textColor = .white
           EventLocation.textColor = .white

    }

 
    // Set up the cell with a UIImage
    // Outlets for the UI components
    @IBOutlet weak var EventName: UILabel!
    @IBOutlet weak var EventStatus: UILabel!
    @IBOutlet weak var EventDate: UILabel!
    @IBOutlet weak var EventSeatslbl: UILabel!
    @IBOutlet weak var EventPhoto: UIImageView!
    @IBOutlet weak var EventDesclbl: UILabel!
    @IBOutlet weak var Pricelbl: UILabel!
    @IBOutlet weak var EventLocation: UILabel!
   

    
    
    
    func setupCell(name: String, startDate: Date, venu: String, status: String, seats: Int, description: String, price: Double, location: String, photoURL: String) {
        // Set the labels with the event data
        EventName.text = name
        
        // Format the start date into a string and set it to EventDate
        EventDate.text = formatDate(startDate)
        
        // Set venue and location labels
        EventLocation.text = venu
        
        // Set the status label
        EventStatus.text = status
        
        // Set the number of seats
        EventSeatslbl.text = "Seats: \(seats)"
        
        // Set the description
        EventDesclbl.text = description
        
        // Set the price label
        Pricelbl.text = "Price: BD\(price)"
        
        // Set the event location label
        EventLocation.text = location
        
        // For Event Photo (download the image from URL)
        if let imageUrl = URL(string: photoURL) {
            downloadImage(from: imageUrl) { image in
                DispatchQueue.main.async {
                    self.EventPhoto.image = image
                }
            }
        } else {
            EventPhoto.image = UIImage(systemName: "photo.fill") // Placeholder image
        }
    }
    

    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d • h:mm a"
        return dateFormatter.string(from: date)
    }

    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }

    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
