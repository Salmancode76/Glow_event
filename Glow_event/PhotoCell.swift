//
//  PhotoCell.swift
//  Glow_event
//
//  Created by PRINTANICA on 01/01/2025.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView! 
    
    func configure(with imageURL: String) {
           // Load the image from the URL
           if let url = URL(string: imageURL) {
               // Asynchronously fetch the image
               URLSession.shared.dataTask(with: url) { data, response, error in
                   if let data = data, error == nil {
                       DispatchQueue.main.async {
                           self.imageView.image = UIImage(data: data)
                       }
                   }
               }.resume()
           }
       }
}
