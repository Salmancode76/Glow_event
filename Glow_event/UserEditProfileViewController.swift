import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UserEditProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize save button appearance
        saveButton.layer.cornerRadius = 10
        saveButton.clipsToBounds = true
        
        // Fetch current user data
        fetchUserData()
    }
    
    // Fetch the current user's data and populate the text fields and image
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
            
            // Populate text fields with existing data
            let name = value["name"] as? String ?? ""
            let email = value["email"] as? String ?? ""
            let phone = value["phone"] as? String ?? ""
            let profileImageUrl = value["profileImageUrl"] as? String ?? ""
            
            DispatchQueue.main.async {
                self.nameTextField.text = name
                self.emailTextField.text = email
                self.phoneTextField.text = phone
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
    
    // Save updated data to Firebase
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let user = Auth.auth().currentUser else {
            print("No user is logged in")
            return
        }
        
        let uid = user.uid
        let databaseRef = Database.database().reference().child("users").child(uid)
        
        // Get the updated values from the text fields
        let updatedName = nameTextField.text ?? ""
        let updatedEmail = emailTextField.text ?? ""
        let updatedPhone = phoneTextField.text ?? ""
        
        // Validate inputs (optional)
        if updatedName.isEmpty || updatedEmail.isEmpty || updatedPhone.isEmpty {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }
        
        // Prepare updated data
        let updatedData: [String: Any] = [
            "name": updatedName,
            "email": updatedEmail,
            "phone": updatedPhone
        ]
        
        // Update the data in the database
        databaseRef.updateChildValues(updatedData) { error, _ in
            if let error = error {
                print("Error updating data: \(error.localizedDescription)")
                self.showAlert(title: "Error", message: "Failed to save changes. Please try again.")
            } else {
                print("User data successfully updated.")
                self.showAlert(title: "Success", message: "Your profile has been updated.")
            }
        }
    }
    
    // Show alert for success or error messages
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    //    /*
    //    // MARK: - Navigation
    //
    //    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        // Get the new view controller using segue.destination.
    //        // Pass the selected object to the new view controller.
    //    }
    //    */
    //
    //}
}
