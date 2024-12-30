
import UIKit

class OrganizersListVC: UIViewController {
    
    @IBOutlet weak var organizerCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var organizers: [Organizer] = []
    var selectedOrganizerIndex: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (organizerCollectionView.frame.width / 2) - 15, height: organizerCollectionView.frame.width / 3)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 15
        organizerCollectionView.collectionViewLayout = layout
        
        organizerCollectionView.delegate = self
        organizerCollectionView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
    }
    
    @objc
    func addTapped() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddOrganizerVC") as! AddOrganizerVC
        vc.organizer = nil // Adding a new organizer
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension OrganizersListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrganizerCell", for: indexPath) as! OrganizerCell
        
        let organizer = organizers[indexPath.item]
        
        // Configure cell with organizer details
        cell.organizerLbl.text = organizer.logo
        cell.organizerLbl.text = organizer.userName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return organizers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddOrganizerVC") as! AddOrganizerVC
        vc.organizer = organizers[indexPath.item] // Pass organizer for editing
        vc.delegate = self
        vc.organizerIndex = indexPath.item
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension OrganizersListVC: AddOrganizerDelegate {
    func didSaveOrganizer(_ organizer: Organizer, at index: Int?) {
        if let index = index {
            organizers[index] = organizer // Edit existing organizer
        } else {
            organizers.append(organizer) // Add new organizer
        }
        organizerCollectionView.reloadData()
    }
}
