//
//  PhotoCell.swift
//  Glow_event
//
//  Created by PRINTANICA on 04/01/2025.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureAppearance()
    }
    
    func configure(with imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        imageView.image = nil
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }
    
    private func configureAppearance() {
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        
    }
}
