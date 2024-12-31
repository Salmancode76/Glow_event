//
//  EventOrgTableViewCell.swift
//
//
//  Created by BP-36-201-09 on 07/12/2024.
//

import UIKit

class EventOrgTableViewCell: UITableViewCell {
    @IBOutlet weak var EventName: UILabel!
    
    @IBOutlet weak var EventStartDate: UILabel!
    @IBOutlet weak var Eventvenu: UILabel!
    @IBOutlet weak var EventImage: UIImageView!
    
    @IBOutlet weak var BookMarkICON: UIImageView!
    
    private var isBookmarked: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.BookMarkICON.isUserInteractionEnabled = true // Ensure interaction
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapBookmark))
        self.BookMarkICON.addGestureRecognizer(tapGestureRecognizer)
        
        EventImage.contentMode = .scaleAspectFill

        updateBookmarkIcon()        // Initialization code
    }
    @objc func didTapBookmark() {
        // Toggle the bookmark state
        isBookmarked.toggle()
        
        print("Bookmark state: \(isBookmarked ? "Filled" : "Empty")")
        
        updateBookmarkIcon()
    }

    private func updateBookmarkIcon() {
        let bookmarkImageName = isBookmarked ? "bookmark.fill" : "bookmark"
        self.BookMarkICON.image = UIImage(systemName: bookmarkImageName)
    }

    
    // Set up the cell with a UIImage
    func setupCell(photo: UIImage, name: String, startDate: Date,venu : String) {
        EventImage.image = photo
        EventName.text = name
        Eventvenu.text = venu
        
        // Format the start date to a string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d • h:mm a"// Adjust format as needed
        EventStartDate.text = dateFormatter.string(from: startDate)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    

        // Configure the view for the selected state
    }
    
    
    
    
    
    

}
