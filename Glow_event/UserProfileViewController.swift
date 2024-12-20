import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UserProfileViewController: UIViewController {
    
    
    // Profile Image and Header Name
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var headerName: UILabel!
    
    // Labels for displaying user data
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch and display user data
        fetchUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // Fetch user data from Firebase Realtime Database
    func fetchUserData() {
        guard let user = Auth.auth().currentUser else {
            print("No user is logged in")
            return
        }
        
        let uid = user.uid
        let databaseRef = Database.database().reference().child("users").child(uid)
        
        databaseRef.observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                print("No data found for this user")
                return
            }
            
            // Extract user data
            let name = value["name"] as? String ?? "No Name"
            let email = value["email"] as? String ?? "No Email"
            let phone = value["phone"] as? String ?? "No Phone"
            let gender = value["gender"] as? String ?? "No Gender"
            let profileImageUrl = value["profileImageUrl"] as? String ?? ""
            
            // Update the UI on the main thread
            DispatchQueue.main.async {
                self.nameLabel.text = name
                self.emailLabel.text = email
                self.phoneLabel.text = phone
                self.genderLabel.text = gender
                self.headerName.text = name
                
                // Configure email label for multi-line support
                self.emailLabel.numberOfLines = 0
                self.emailLabel.lineBreakMode = .byWordWrapping
                self.emailLabel.adjustsFontSizeToFitWidth = true
                self.emailLabel.minimumScaleFactor = 0.5
            }
            
            // Load the profile image if URL is available
            if !profileImageUrl.isEmpty {
                self.loadProfileImage(from: profileImageUrl)
            } else {
                DispatchQueue.main.async {
                    self.setPlaceholderImage()
                }
            }
        } withCancel: { error in
            print("Error fetching user data: \(error.localizedDescription)")
        }
    }
    
    // Load the profile image from a URL
    func loadProfileImage(from url: String) {
        guard let imageUrl = URL(string: url) else {
            setPlaceholderImage()
            print("Invalid profile image URL")
            return
        }
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: imageUrl)
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profileImageView.image = image
                        
                        // Make the profile image view circular
                        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
                        self.profileImageView.clipsToBounds = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.setPlaceholderImage()
                        print("Failed to decode image data.")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.setPlaceholderImage()
                    print("Error loading image: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Set a placeholder image in case of errors or missing URL
    private func setPlaceholderImage() {
        self.profileImageView.image = UIImage(systemName: "person.circle")
        self.profileImageView.tintColor = .gray
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        self.profileImageView.clipsToBounds = true
    }
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


