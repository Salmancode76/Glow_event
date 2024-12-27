import Firebase
import FirebaseAuth
import FirebaseDatabase
import UIKit

class UserDetailViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var user: [String: Any]? // variable to recieve user data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteButton.tintColor = UIColor(red: 187/255, green: 75/255, blue: 75/255, alpha: 1.0)

        // load selected user details
        if let user = user {
            nameLabel.text = user["name"] as? String ?? "No Name"
            ageLabel.text = "\(user["age"] ?? "No Age")"
            emailLabel.text = user["email"] as? String ?? "No Email"
            
            // load profile image
            if let profileImageUrl = user["profileImageUrl"] as? String, let url = URL(string: profileImageUrl) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.profileImageView.image = image
                            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width / 2
                            self.profileImageView.clipsToBounds = true
                        }
                    }
                }.resume()
            } else {
                // set placeholder image
                profileImageView.image = UIImage(systemName: "person.circle")
            }
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        guard let uid = user?["uid"] as? String else {
                print("Error: User UID not found")
                return
            }
            
            let alert = UIAlertController(title: "Delete User", message: "Are you sure you want to delete this user?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                let databaseRef = Database.database().reference().child("users").child(uid)
                databaseRef.removeValue { error, _ in
                    if let error = error {
                        print("Error deleting user: \(error.localizedDescription)")
                    } else {
                        print("User deleted successfully")
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }))
            
            present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditUserSegue",
           let destinationVC = segue.destination as? EditUserViewController {
            
            // pass the userID to the EditUserViewController
            destinationVC.userID = user?["uid"] as? String
        }
    }
    }
