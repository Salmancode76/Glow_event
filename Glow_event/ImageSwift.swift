//
//  ImageSwift.swift
//  Glow_event
//
//  Created by PRINTANICA on 03/01/2025.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(from url: URL) {
        
        
        
        self.image = nil

               // Create a URLSession data task to fetch the image
               let task = URLSession.shared.dataTask(with: url) { data, response, error in
                   // Check for errors and valid data
                   guard let data = data, error == nil else { return }
                   DispatchQueue.main.async {
                       // Create a UIImage from the data and set it to the image view
                       self.image = UIImage(data: data)
                   }
               }
               task.resume() // Start the task
       
                }
            
        
    
}
