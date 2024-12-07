//
//  EventOrgTableViewCell.swift
//  
//
//  Created by BP-36-201-09 on 07/12/2024.
//

import UIKit

class EventOrgTableViewCell: UITableViewCell {
    @IBOutlet weak var EventName: UILabel!
    
    @IBOutlet weak var EventImage: UIImageView!  

    override func awakeFromNib() {
        super.awakeFromNib()
        EventImage.contentMode = .scaleAspectFill // Adjust based on your needs

        // Initialization code
    }
    
    // Set up the cell with a UIImage
    func setupCell(photo: UIImage,name : String) {
           EventImage.image = photo
        EventName.text = name

       }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    

        // Configure the view for the selected state
    }
    
    
    
    

}

