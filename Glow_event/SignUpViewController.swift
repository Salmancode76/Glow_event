//
//  SignUpViewController.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 22/12/2024.
//

import Foundation
import UIKit
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var isRegistrationSuccessful = false
    
    var userTypeToNavigate: UserType?
    
    @IBOutlet weak var firstName: UITextField!
    
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var age: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var genderPicker: UIPickerView!
    
    let genderOptions = Gender.allCases.map { $0.rawValue }
    
    var selectedGender: Gender = .male
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        firstName.delegate = self
        lastName.delegate = self
        password.delegate = self
        email.delegate = self
        age.delegate = self
        phone.delegate = self
        genderPicker.delegate = self
        genderPicker.dataSource = self
        
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set the flag when the signup screen appears
        (UIApplication.shared.delegate as? AppDelegate)?.isInRegistrationFlow = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Reset the flag when leaving the signup screen
        (UIApplication.shared.delegate as? AppDelegate)?.isInRegistrationFlow = false
    }*/
    
    //UIPickerViewDataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 };
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return genderOptions.count }
    
    // UIPickerViewDelegate methods
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return genderOptions[row] };
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { selectedGender = Gender(rawValue: genderOptions[row]) ?? .male }
    
    
    // Action for the sign-up button
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        if validateFields() {
                registerUser()
            }
    }
    
    // Function to validate all input fields
    func validateFields() -> Bool {
        // Validate first name
        guard let firstNameText = firstName.text, !firstNameText.isEmpty, firstNameText.count >= 3 else {
            showAlert(title: "Empty Field", message: "Please Enter Your First Name")
            return false
        }
        
        // Validate last name
        guard let lastNameText = lastName.text, !lastNameText.isEmpty, lastNameText.count >= 3 else {
            showAlert(title: "Empty Field", message: "Please Enter Your Last Name")
            return false
        }
        
        // Validate password
        guard let passwordText = password.text, !passwordText.isEmpty, passwordText.count >= 8 else {
            showAlert(title: "Weak Password", message: "Password must be at least 8 characters long")
            return false
        }
        
        // Validate email
        guard let emailText = email.text, !emailText.isEmpty, isValidEmail(emailText) else {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address")
            return false
        }
        
        // Validate age
        guard let ageText = age.text, let ageValue = Int(ageText), ageValue > 0 else {
            showAlert(title: "Invalid Age", message: "Please enter a valid age")
            return false
        }
        
        // Validate phone
        guard let phoneText = phone.text, !phoneText.isEmpty, isValidPhone(phoneText) else {
            showAlert(title: "Invalid Phone", message: "Please enter a valid 8-digit phone number")
            return false
        }
        
        return true
    }
    
    // Email validation
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{3,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // Phone validation
    func isValidPhone(_ phone: String) -> Bool {
        let phoneRegex = "^[0-9]{8}$" // Regex for 8 digits phone number
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone)
    }
    
    // Show alert messages
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
 
    // Function to register user in Firebase
    func registerUser() {
        guard let emailText = email.text,
              let passwordText = password.text,
              let firstNameText = firstName.text, let lastNameText = lastName.text,
              let ageText = age.text, let ageValue = Int(ageText),
              let phoneText = phone.text else {
            return }
        
        // Determine user type based on the email
        let userType: String
        if emailText.hasPrefix("eventorganizer") {
            userType = "eventOrganizer"
        } else if emailText.hasPrefix("admin") {
            userType = "admin"
        } else {
            userType = "user1" // Default to normal user
        }
        
        Auth.auth().createUser(withEmail: emailText, password: passwordText) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.showAlert(title: "Registration Error", message: error.localizedDescription)
                return
            }
            
            guard let user = authResult?.user else { return }
            let db = Firestore.firestore()
            db.collection("users").document(user.uid).setData([
                "firstName": firstNameText,
                "lastName": lastNameText,
                "email": emailText,
                "age": ageValue,
                "phone": phoneText,
                "gender": self.selectedGender.rawValue,
                "userType": userType
            ]) { error in
                if let error = error {
                    print("Error saving user data: \(error.localizedDescription)")
                    self.showAlert(title: "Error", message: "Could not save user data.")
                } else {
                    print("User data saved successfully")
                    //self.isRegistrationSuccessful = true
                    self.showHomeScreen(for: user.uid)
                }
            }
        }
    }
    
    
    
    func showHomeScreen(for userId: String) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] document, error in
            if let document = document, document.exists {
                let data = document.data()
                let userTypeString = data?["userType"] as? String ?? ""
                
                let userType: UserType
                switch userTypeString {
                case "admin":
                    userType = .admin
                case "eventOrganizer":
                    userType = .eventOrganizer
                default:
                    userType = .user1
                }
                
                self?.navigateToHomeScreen(for: userType)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func navigateToHomeScreen(for userType: UserType) {
        var destinationVC: UIViewController?
        
        switch userType {
        case .admin:
            destinationVC = storyboard?.instantiateViewController(withIdentifier: "adminHomeVC") as? AdminHomeViewController
        case .eventOrganizer:
            destinationVC = storyboard?.instantiateViewController(withIdentifier: "eventOrganizerHomeVC") as? EventOrganizerHomeViewController
        case .user1:
            destinationVC = storyboard?.instantiateViewController(withIdentifier: "userHomeVC") as? UserHomeViewController
        }
        
        if let destinationVC = destinationVC {
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
  
}

