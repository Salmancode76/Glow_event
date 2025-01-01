//
//  PhotosClassViewController.swift
//  Glow_event
//
//  Created by PRINTANICA on 01/01/2025.
//

import UIKit
import FirebaseDatabase



class PhotosClassViewController: UIViewController, UICollectionViewDelegate
{
    
    var organizerName: String?
    var highlights: [String] = []
    
    
    @IBOutlet weak var CollectionViiew: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CollectionViiew.dataSource = self
        //  CollectionViiew .delegate = self
        
        /*  if let name = organizerName {
         loadHighlights(for: name)
         }
         
         }
         
         // private func loadHighlights(for name: String) {
         // Reference to your Firebase database
         // let ref = Database.database().reference().child("highlights").child(name)
         
         // ref.observeSingleEvent(of: .value) { snapshot,}  in
         // Check if the snapshot contains data
         //  guard let data = snapshot.value as? [String: Any],
         // let highlightsData = data["highlights"] as? [String] else {
         //  print("No highlights found for \(name)")
         // return
         }
         
         //   self.highlights = highlightsData // Update highlights array
         //  self.collectionView.reloadData() // Reload collection view
         //   } withCancel: { error in
         // print("Error fetching highlights: \(error.localizedDescription)")
         // }
         
         //  }
         ///
         
         //  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         // return highlights.count
         // }
         
         // func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         // let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HighlightCell", for: indexPath) as! PhotoCell
         
         // Configure the cell with the highlight image URL
         // let highlightImageURL = highlights[indexPath.item]
         /*   cell.configure(with: highlightImageURL) // Assuming you have a method to configure the cell
          
          return cell
          }
          }
          
          
          
          
          
          // Ensure the collection view is already connected in the storyboard or programmatically added elsewhere.
          
          
          //fetchHighlights()
          // Do any additional setup after loading the view.
          
          
          
          
          
          
          
          
          
          /*
           // MARK: - Navigation
           
           // In a storyboard-based application, you will often want to do a little preparation before navigation
           override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           // Get the new view controller using segue.destination.
           // Pass the selected object to the new view controller.
           }
           }
           
           
           
           
           */*/*/
    }
    
}
