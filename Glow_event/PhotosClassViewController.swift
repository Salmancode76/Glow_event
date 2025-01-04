//
//  PhotosClassViewController.swift
//  Glow_event
//
//  Created by PRINTANICA on 04/01/2025.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class PhotosClassViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var databaseRef: DatabaseReference!
    var highlights: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self

        databaseRef = Database.database().reference()

        fetchHighlights()
        // Do any additional setup after loading the view.
    }
    
    
    
    private func fetchHighlights() {
        guard let organizerID = Auth.auth().currentUser?.uid else {
            print("No logged-in user found.")
            showErrorAlert(message: "You must be logged in to view highlights.")
            return
        }

        print("Fetching highlights for organizer ID: \(organizerID)")

        databaseRef.child("organizers").child(organizerID).child("highlights").observeSingleEvent(of: .value) { snapshot in
            var tempHighlights: [[String: Any]] = []

            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   var highlightData = childSnapshot.value as? [String: Any] {
                    highlightData["key"] = childSnapshot.key
                    tempHighlights.append(highlightData)
                }
            }

            self.highlights = tempHighlights
            print("Highlights fetched: \(self.highlights)")
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension PhotosClassViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return highlights.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }

        let highlight = highlights[indexPath.row]

        // Pass the image URL to the cell
        if let imageUrlString = highlight["imageUrl"] as? String {
            cell.configure(with: imageUrlString)
        }

        return cell
    }
}

extension PhotosClassViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let highlight = highlights[indexPath.row]

        guard let organizerID = Auth.auth().currentUser?.uid else {
            showErrorAlert(message: "You must be logged in to perform this action.")
            return
        }

        let alert = UIAlertController(title: "Delete Highlight", message: "Are you sure you want to delete this highlight?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            // Get the Firebase key for the selected highlight
            if let highlightKey = highlight["key"] as? String {
                // Delete the highlight from Firebase
                self.databaseRef.child("organizers").child(organizerID).child("highlights").child(highlightKey).removeValue { error, _ in
                    if let error = error {
                        self.showErrorAlert(message: "Failed to delete highlight: \(error.localizedDescription)")
                        return
                    }

                    self.highlights.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            } else {
                self.showErrorAlert(message: "Invalid highlight key.")
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension PhotosClassViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = 4
        let totalPadding = (spacing * (numberOfItemsPerRow - 1)) + (spacing * 2)
        let availableWidth = collectionView.frame.width - totalPadding
        let widthPerItem = availableWidth / numberOfItemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
