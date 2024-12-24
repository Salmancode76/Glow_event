//
//  AdminCategoriesViewController.swift
//  Glow_event
//
//  Created by Thuraya AlSatrawi on 19/12/2024.
//

import UIKit

class AdminCategoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    // Example categories
    var categories = ["Sports", "Concerts", "Exhibitions", "Gaming"]
    var filteredCategories = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Register the custom cell
        let nib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CategoryCell")
        
        // Set up search bar
        searchBar.delegate = self
        
        // Initialize filtered categories
        filteredCategories = categories
    }
    
    // MARK: - UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
        cell.categoryLabel.text = filteredCategories[indexPath.row]
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 32) / 2 // Two items per row with spacing
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected category: \(filteredCategories[indexPath.row])")
    }

    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredCategories = categories
        } else {
            filteredCategories = categories.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        collectionView.reloadData()
    }
}
