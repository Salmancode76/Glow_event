//
//  AdminViewOrganizersController.swift
//  Glow_event
//
//  Created by Thuraya AlSatrawi on 18/12/2024.
//

import UIKit

class AdminOrganizersViewController: UICollectionViewController {
    
    // Example data for organizers
    let organizers = [
        ["name": "Allayali events", "image": "logo1"], // Add images to Assets
        ["name": "Over 338", "image": "logo2"],
        ["name": "JMStrings entertainment", "image": "logo3"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Organizers"
        
        // Register the custom cell
        let nib = UINib(nibName: "OrganizerCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "OrganizerCell")
    }
    
    // MARK: - UICollectionView DataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return organizers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrganizerCell", for: indexPath) as! OrganizerCollectionViewCell
        
        let organizer = organizers[indexPath.row]
        cell.nameLabel.text = organizer["name"]
        cell.logoImageView.image = UIImage(named: organizer["image"] ?? "placeholder") // Add images to Assets
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        
        return cell
    }
    
    // MARK: - UICollectionView Delegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected Organizer: \(organizers[indexPath.row]["name"]!)")
    }
}
