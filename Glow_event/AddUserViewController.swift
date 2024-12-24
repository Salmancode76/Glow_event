import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AddUserViewController: UIViewController {

    // Outlets for input fields and button
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addUserTapped(_ sender: UIButton) {
        // Fetching user input
        guard let username = usernameTextField.text, !username.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let gender = genderTextField.text, !gender.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all the required fields.")
            return
        }
        
        // Validating password length
        if password.count < 8 {
            showAlert(title: "Error", message: "Password must be at least 8 characters long.")
            return
        }
        
        // Validate gender input
        let validGenders = ["Male", "Female"]
        if !validGenders.contains(gender.capitalized) {
            showAlert(title: "Error", message: "Gender must be either 'Male' or 'Female'.")
            return
        }
        
        // Add the user to Firebase Authentication
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                self.showAlert(title: "Error", message: "Failed to create user. \(error.localizedDescription)")
                return
            }
            
            guard let user = authResult?.user else {
                self.showAlert(title: "Error", message: "Failed to create user. Please try again.")
                return
            }
            
            print("User created successfully with UID: \(user.uid)")
            
            // Save user details in the Realtime Database
            let userData: [String: Any] = [
                "username": username,
                "email": email,
                "gender": gender.capitalized,
                "uid": user.uid,
                "phone": "",
                "profileImageUrl": ""
            ]
            
            let databaseRef = Database.database().reference().child("users").child(user.uid)
            databaseRef.setValue(userData) { error, _ in
                if let error = error {
                    print("Error saving user data to database: \(error.localizedDescription)")
                    self.showAlert(title: "Error", message: "Failed to save user data. \(error.localizedDescription)")
                } else {
                    print("User data saved successfully to database.")
                    self.showAlert(title: "Success", message: "User added successfully.")
                    self.clearFields()
                }
            }
        }
    }
    
    private func clearFields() {
        usernameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        genderTextField.text = ""
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
