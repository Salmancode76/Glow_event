//
//  SavedEventsTableViewCell.swift
//  Glow_event
//
//  Created by Thuraya AlSatrawi on 09/12/2024.
//

import UIKit

class SavedEventsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventPic: UIImageView!
    
    @IBOutlet weak var dateTimeLbl: UILabel!
    
    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var eventLocation: UILabel!
    
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func eventInit(_ dateTime: String, _ eventImg: String, _ event: String, _ eventLoc: String){
        eventPic.image = UIImage(named: eventImg)
        dateTimeLbl.text = dateTime
        eventName.text = event
        eventLocation.text = eventLoc
    }
    
}
