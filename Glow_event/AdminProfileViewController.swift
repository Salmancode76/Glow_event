import Firebase
import FirebaseAuth
import FirebaseDatabase
import UIKit

class AdminProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            fetchAdminData()
        }
        
        // Method to retrieve the current user's data from Firebase and populate the labels and image
        func fetchAdminData() {
            guard let user = Auth.auth().currentUser else {
                print("No admin is logged in")
                return
            }
            
            let uid = user.uid
            let databaseRef = Database.database().reference().child("admins").child(uid)
            
            databaseRef.observeSingleEvent(of: .value) { snapshot in
                guard let value = snapshot.value as? [String: Any] else {
                                print("No data found for this admin")
                                return
                            }
                            
                            // Extract admin data
                            let id = value["id"] as? Int ?? 0
                            let email = value["email"] as? String ?? "No Email"
                            let profileImageUrl = value["profileImageUrl"] as? String ?? ""
                            
                            DispatchQueue.main.async {
                                self.idLabel.text = "\(id)"
                                self.emailLabel.text = email
                            }
                
                // Load the profile image
                if !profileImageUrl.isEmpty {
                    self.loadProfileImage(from: profileImageUrl)
                } else {
                    DispatchQueue.main.async {
                        self.setPlaceholderImage()
                    }
                }
            } withCancel: { error in
                print("Error fetching admin data: \(error.localizedDescription)")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
