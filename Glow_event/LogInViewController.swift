//
//  LogInViewController.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 26/12/2024.
//

import SwiftUI
import UIKit
import FirebaseAuth
import FirebaseFirestore

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    // Variable to store user type
    var userTypeToNavigate: UserType?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional setup if needed
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        if validateFields() {
            loginUser()
        }
    }
    
    // Function to validate input fields
    func validateFields() -> Bool {
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Empty Field", message: "Please enter your email.")
            return false
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Empty Field", message: "Please enter your password.")
            return false
        }
        
        return true
    }
    
    // Function to show alert messages
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Function to log in the user
    func loginUser() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.showAlert(title: "Login Error", message: error.localizedDescription)
                return
            }
            
            guard let user = authResult?.user else {
                self.showAlert(title: "Login Error", message: "User not found.")
                return
            }
            
            // Set the user ID in GlobalUser
            GlobalUser.shared.currentUser = User(uid: user.uid, username: email, password: password, userType: self.userTypeToNavigate ?? .user1)
            
            self.fetchUserData(for: user.uid)
                }
            }
            
            // Function to fetch user data from Firestore
        func fetchUserData(for userId: String) {
            let db = Firestore.firestore()
            db.collection("users").document(userId).getDocument { [weak self] document, error in
                guard let self = self else { return }
    
                if let document = document, document.exists {
                    let data = document.data()
                    let userTypeString = data?["userType"] as? String ?? ""
    
                    // Determine user type
                    switch userTypeString {
                    case "admin":
                        self.userTypeToNavigate = .admin
                    case "eventOrganizer":
                        self.userTypeToNavigate = .eventOrganizer
                    default:
                        self.userTypeToNavigate = .user1
                    }
                    
                    // Set the current user type in GlobalUser
                    GlobalUser.shared.currentUserType = self.userTypeToNavigate
                    
                    // Navigate to the home screen
                    self.navigateToHomeScreen()

                } else {
                    self.showAlert(title: "Login Error", message: "No such account exists. Please create an account.")
                }
            }
        }
    
    func navigateToHomeScreen() {
            var destinationVC: UIViewController?
    
            switch userTypeToNavigate {
            case .admin:
                destinationVC = storyboard?.instantiateViewController(withIdentifier: "adminHomeVC") as? AdminHomeViewController
            case .eventOrganizer:
                destinationVC = storyboard?.instantiateViewController(withIdentifier: "eventOrganizerHomeVC") as? EventOrganizerHomeViewController
            case .user1:
                destinationVC = storyboard?.instantiateViewController(withIdentifier: "userHomeVC") as? UserHomeViewController
            default:
                return
            }
    
            if let destinationVC = destinationVC {
                navigationController?.pushViewController(destinationVC, animated: true)
            }
        }
    }
    
        
