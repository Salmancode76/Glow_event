//import UIKit
//import Firebase
//import FirebaseAuth
//import FirebaseDatabase
//
//class EOProfileViewController: UIViewController {
//    
//    // UI Outlets
//    @IBOutlet weak var profileImageView: UIImageView!
//    @IBOutlet weak var headerNameLabel: UILabel!
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var emailLabel: UILabel!
//    @IBOutlet weak var websiteLabel: UILabel!
//    @IBOutlet weak var phoneLabel: UILabel!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Fetch and display event organizer data
//        fetchOrganizerData()
//        
//        // Set up the profile image view appearance
//        setupProfileImageView()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//    }
//    
//    // MARK: - Fetch Organizer Data
//    func fetchOrganizerData() {
//        guard let user = Auth.auth().currentUser else {
//            print("No user is logged in")
//            return
//        }
//        
//        let uid = user.uid
//        let databaseRef = Database.database().reference().child("organizers").child(uid)
//        
//        databaseRef.observeSingleEvent(of: .value) { snapshot in
//            guard let value = snapshot.value as? [String: Any] else {
//                print("No data found for this organizer")
//                return
//            }
//            
//            // Extract organizer data
//            let name = value["name"] as? String ?? "No Name"
//            let email = value["email"] as? String ?? "No Email"
//            let website = value["website"] as? String ?? "No Website"
//            let phone = value["phone"] as? String ?? "No Phone"
//            let profileImageUrl = value["profileImageUrl"] as? String ?? ""
//            
//            // Update the UI on the main thread
//            DispatchQueue.main.async {
//                self.nameLabel.text = name
//                self.emailLabel.text = email
//                self.websiteLabel.text = website
//                self.phoneLabel.text = phone
//                self.headerNameLabel.text = name
//                
//                // Configure multi-line support for labels
//                [self.emailLabel, self.websiteLabel].forEach { label in
//                    label?.numberOfLines = 0
//                    label?.lineBreakMode = .byWordWrapping
//                    label?.adjustsFontSizeToFitWidth = true
//                    label?.minimumScaleFactor = 0.5
//                }
//            }
//            
//            // Load the profile image if URL is available
//            if !profileImageUrl.isEmpty {
//                self.loadProfileImage(from: profileImageUrl)
//            } else {
//                DispatchQueue.main.async {
//                    self.setPlaceholderImage()
//                }
//            }
//        } withCancel: { error in
//            print("Error fetching organizer data: \(error.localizedDescription)")
//        }
//    }
//    
//    // MARK: - Load Profile Image
//    func loadProfileImage(from url: String) {
//        guard let imageUrl = URL(string: url) else {
//            setPlaceholderImage()
//            print("Invalid profile image URL")
//            return
//        }
//        
//        DispatchQueue.global().async {
//            do {
//                let data = try Data(contentsOf: imageUrl)
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self.profileImageView.image = image
//                        
//                        // Make the profile image view circular
//                        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
//                        self.profileImageView.clipsToBounds = true
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        self.setPlaceholderImage()
//                        print("Failed to decode image data.")
//                    }
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.setPlaceholderImage()
//                    print("Error loading image: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//    
//    // MARK: - Placeholder Image
//    private func setPlaceholderImage() {
//        self.profileImageView.image = UIImage(systemName: "person.circle")
//        self.profileImageView.tintColor = .gray
//        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
//        self.profileImageView.clipsToBounds = true
//    }
//    
//    // MARK: - Profile Image Setup
//    private func setupProfileImageView() {
//        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
//        profileImageView.clipsToBounds = true
//        profileImageView.contentMode = .scaleAspectFill
//        profileImageView.layer.borderWidth = 2.0
//        profileImageView.layer.borderColor = UIColor.white.cgColor // Optional border
//    }
//}
