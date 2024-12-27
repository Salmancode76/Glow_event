import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class AddUserViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // Outlets for input fields and button
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    let genders = ["Male", "Female"] // storing gender options in an array (for the picker)
    let picker = UIPickerView() // creating a picker instance
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            addButton.tintColor = UIColor(red: 62/255, green: 35/255, blue: 120/255, alpha: 1.0)
            
            // set up the picker
            picker.delegate = self
            picker.dataSource = self
            
            // binding the picker to the gender text field
            genderTextField.inputView = picker
            
            // adding a toolbar with a done button for the picker
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPicker))
            toolbar.setItems([doneButton], animated: false)
            toolbar.isUserInteractionEnabled = true
            genderTextField.inputAccessoryView = toolbar
            
            // set white placeholder color
            setPlaceholderColor(for: usernameTextField, text: "Username")
            setPlaceholderColor(for: emailTextField, text: "Email")
            setPlaceholderColor(for: passwordTextField, text: "Password")
            setPlaceholderColor(for: genderTextField, text: "Gender")
            
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
    
        // method to setup placeholders color to white
        private func setPlaceholderColor(for textField: UITextField, text: String) {
                textField.attributedPlaceholder = NSAttributedString(
                    string: text,
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
                )
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
