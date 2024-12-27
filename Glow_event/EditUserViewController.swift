import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class EditUserViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // text fields and button outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var userID: String? // Identifying the user being edited
        
        let genders = ["Male", "Female"] // Gender options for the picker
        let picker = UIPickerView() // Picker instance
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            saveButton.tintColor = UIColor(red: 62/255, green: 35/255, blue: 120/255, alpha: 1.0)
            
            fetchUserData() // Fetch and display user data
            
            // Set up the gender picker
            picker.delegate = self
            picker.dataSource = self
            
            // Assign the picker to the gender text field
            genderTextField.inputView = picker
            
            // Add a toolbar with a Done button for the picker
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPicker))
            toolbar.setItems([doneButton], animated: false)
            toolbar.isUserInteractionEnabled = true
            genderTextField.inputAccessoryView = toolbar
            
            // disable the keyboard for the gender text field
            genderTextField.isUserInteractionEnabled = true
            genderTextField.tintColor = .clear // remove the cursor
        }
        
        @objc func dismissPicker() {
            view.endEditing(true) // Dismiss the picker
        }
        
        // MARK: - UIPickerViewDataSource
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1 // Only one column for genders
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return genders.count // Number of genders
        }
        
        // MARK: - UIPickerViewDelegate
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return genders[row] // Display the gender options
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            genderTextField.text = genders[row] // Set the selected gender to the text field
        }
        
        // Fetching the user details from Firebase to populate the fields
        private func fetchUserData() {
            guard let userID = userID else {
                print("User ID is missing")
                return
            }
            
            let databaseRef = Database.database().reference().child("users").child(userID)
            
            databaseRef.observeSingleEvent(of: .value) { snapshot in
                guard let value = snapshot.value as? [String: Any] else {
                    print("No data found for this user")
                    return
                }
                
                // Populate the text fields with the fetched data
                let username = value["username"] as? String ?? ""
                let email = value["email"] as? String ?? ""
                let gender = value["gender"] as? String ?? ""
                
                DispatchQueue.main.async {
                    self.usernameTextField.text = username
                    self.emailTextField.text = email
                    self.genderTextField.text = gender
                    self.passwordTextField.text = "" // Password is not fetched for security reasons
                }
            } withCancel: { error in
                print("Error fetching user data: \(error.localizedDescription)")
            }
        }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text, !username.isEmpty,
                  let email = emailTextField.text, !email.isEmpty,
                  let gender = genderTextField.text, !gender.isEmpty else {
                showAlert(title: "Error", message: "Please fill in all fields.")
                return
            }
            
            let validGenders = ["Male", "Female"]
            if !validGenders.contains(gender.capitalized) {
                showAlert(title: "Error", message: "Gender must be 'Male' or 'Female'.")
                return
            }
            
            if let password = passwordTextField.text, !password.isEmpty, password.count < 8 {
                showAlert(title: "Error", message: "Password must be at least 8 characters long.")
                return
            }
            
            guard let userID = userID else {
                print("User ID is missing")
                return
            }
            
            let databaseRef = Database.database().reference().child("users").child(userID)
            var updatedData: [String: Any] = [
                "username": username,
                "email": email,
                "gender": gender
            ]
            
            if let password = passwordTextField.text, !password.isEmpty {
                Auth.auth().currentUser?.updatePassword(to: password) { error in
                    if let error = error {
                        self.showAlert(title: "Error", message: "Failed to update password: \(error.localizedDescription)")
                    } else {
                        print("Password updated successfully")
                    }
                }
            }
            
            databaseRef.updateChildValues(updatedData) { error, _ in
                if let error = error {
                    self.showAlert(title: "Error", message: "Failed to update user data: \(error.localizedDescription)")
                } else {
                    self.showAlert(title: "Success", message: "User details updated successfully.")
                    self.navigationController?.popViewController(animated: true)
                }
            }
            }
            
            // Show alert for validation or success/error messages
            private func showAlert(title: String, message: String) {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
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

