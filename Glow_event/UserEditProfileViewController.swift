import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UserEditProfileViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    // MARK: - Properties
        let genderPicker = UIPickerView()
        let genderOptions = ["Male", "Female"]
        
        // MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupUI()
            setupGenderPicker()
            fetchUserData()
        }
        
        // MARK: - Setup UI
        private func setupUI() {
            saveButton.tintColor = UIColor(red: 62/255, green: 35/255, blue: 120/255, alpha: 1.0)
            
            // Make the profile image view circular
            profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
            profileImageView.clipsToBounds = true
        }
        
        // MARK: - Gender Picker Setup
        private func setupGenderPicker() {
            genderPicker.delegate = self
            genderPicker.dataSource = self
            genderTextField.inputView = genderPicker
            
            // Add a toolbar with a Done button
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPicker))
            toolbar.setItems([doneButton], animated: false)
            toolbar.isUserInteractionEnabled = true
            genderTextField.inputAccessoryView = toolbar
            genderTextField.tintColor = .clear // Remove cursor
        }
        
        @objc private func dismissPicker() {
            view.endEditing(true) // Dismiss the picker
        }
        
        // MARK: - UIPickerViewDataSource
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1 // Single column for gender options
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return genderOptions.count
        }
        
        // MARK: - UIPickerViewDelegate
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return genderOptions[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            genderTextField.text = genderOptions[row]
        }
        
        // MARK: - Fetch User Data
    private func fetchUserData() {
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
                
                let name = value["name"] as? String ?? ""
                let email = value["email"] as? String ?? ""
                let phone = value["phone"] as? String ?? ""
                let gender = value["gender"] as? String ?? ""
                let profileImageUrl = value["profileImageUrl"] as? String ?? ""
                
                DispatchQueue.main.async {
                    self.nameTextField.text = name
                    self.emailTextField.text = email
                    self.phoneTextField.text = phone
                    self.genderTextField.text = gender
                    
                    if let index = self.genderOptions.firstIndex(of: gender) {
                        self.genderPicker.selectRow(index, inComponent: 0, animated: false)
                    }
                    
                    if !profileImageUrl.isEmpty {
                        self.loadProfileImage(from: profileImageUrl)
                    } else {
                        self.setPlaceholderImage()
                    }
                }
            }
        }
        
        private func loadProfileImage(from url: String) {
            guard let imageUrl = URL(string: url) else {
                setPlaceholderImage()
                return
            }
            
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: imageUrl)
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.profileImageView.image = image
                        }
                    }
                } catch {
                    self.setPlaceholderImage()
                }
            }
        }
        
        private func setPlaceholderImage() {
        self.profileImageView.image = UIImage(systemName: "person.circle")
        self.profileImageView.tintColor = .gray
    }
        
        // MARK: - Save Button Action
        @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let user = Auth.auth().currentUser else {
            print("No user is logged in")
            return
        }
        
        let uid = user.uid
        let databaseRef = Database.database().reference().child("users").child(uid)
        
        // Collect updated data
        let updatedData: [String: Any] = [
            "name": nameTextField.text ?? "",
            "email": emailTextField.text ?? "",
            "phone": phoneTextField.text ?? "",
            "gender": genderTextField.text ?? ""
        ]
        
        // Update the data in the database
        databaseRef.updateChildValues(updatedData) { error, _ in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            } else {
                self.showAlert(title: "Success", message: "Profile updated successfully.")
            }
        }
    }
    
        // MARK: - Show Alert
        private func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
