//
//  CategoryCell.swift
//  Glow_event
//
//  Created by PRINTANICA on 06/01/2025.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var category: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        icon.isHidden = true
        // Initialization code
    }
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
