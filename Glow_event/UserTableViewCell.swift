import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // set the content mode to scale and fill
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Ensure the image is circular
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
    }
}
