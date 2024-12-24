import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AdminChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.tintColor = UIColor(red: 62/255, green: 35/255, blue: 120/255, alpha: 1.0)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let oldPassword = oldPasswordTextField.text, !oldPassword.isEmpty,
              let newPassword = newPasswordTextField.text, !newPassword.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }
        
        if newPassword != confirmPassword {
            showAlert(title: "Error", message: "New password and confirmation do not match.")
            return
        }
        
        if newPassword.count < 8 {
            showAlert(title: "Error", message: "Password must be at least 8 characters long.")
            return
        }
        
        // validate user's old password through firebase
        validateOldPassword(oldPassword: oldPassword) { [weak self] isValid in
            guard let self = self else { return }
                    
            if isValid { // If old password is valid, update to new password
            self.updatePassword(to: newPassword)
            } else {
            self.showAlert(title: "Error", message: "The current password is incorrect.")
            }
        }
    }
    
    private func validateOldPassword(oldPassword: String, completion: @escaping (Bool) -> Void) {
            guard let user = Auth.auth().currentUser, let email = user.email else {
                completion(false)
                return
            }
            
            // Reauthenticate user with old password
            let credential = EmailAuthProvider.credential(withEmail: email, password: oldPassword)
            user.reauthenticate(with: credential) { _, error in
                if let error = error {
                    print("Reauthentication failed: \(error.localizedDescription)")
                    completion(false) // Change this to `false` for failed reauthentication
                } else {
                    print("Reauthentication successful.")
                    completion(true)
                }
        }
    }
    
    private func updatePassword(to newPassword: String) {
            guard let user = Auth.auth().currentUser else { // Retrieve current user
                showAlert(title: "Error", message: "Unable to retrieve user.")
                return
            }
            
            user.updatePassword(to: newPassword) { [weak self] error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Password update failed: \(error.localizedDescription)")
                    self.showAlert(title: "Error", message: "Failed to update password. Please try again.")
                } else {
                    print("Password updated successfully.")
                    self.updateDatabasePassword(newPassword)
                    self.showAlert(title: "Success", message: "Your password has been updated.")
                    self.clearFields()
                }
            }
        }
        
        private func updateDatabasePassword(_ newPassword: String) {
            guard let user = Auth.auth().currentUser else {
                print("Unable to update database: User not found.")
                return
            }
            
            let uid = user.uid
            let databaseRef = Database.database().reference().child("users").child(uid)
            
            databaseRef.updateChildValues(["password": newPassword]) { error, _ in
                if let error = error {
                    print("Failed to update password in database: \(error.localizedDescription)")
                } else {
                    print("Password successfully updated in the database.")
                }
            }
        }
    
    private func clearFields() {
        oldPasswordTextField.text = ""
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
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
