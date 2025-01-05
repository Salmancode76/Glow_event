import FirebaseAuth
import UIKit

class EventOrgLoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showErrorAlert(message: "Please enter both email and password.")
            return
        }
        
        print("Attempting to sign in as an Event Organizer with email: \(email)")
        
        // Use Firebase Authentication to validate the credentials
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Firebase sign-in error: \(error.localizedDescription)")
                self.showErrorAlert(message: error.localizedDescription)
                return
            }
            
            // Successfully signed in
            if let user = authResult?.user {
                print("Sign-in successful. User ID: \(user.uid), Email: \(user.email ?? "No Email")")
                self.navigateToSettingsScreen()
            } else {
                print("Unexpected error: User is nil.")
                self.showErrorAlert(message: "An unexpected error occurred. Please try again.")
            }
        }
    }
    
    private func navigateToSettingsScreen() {
        print("Attempting to navigate to EventOrgSettingsTableViewController")
        
        if let settingsVC = storyboard?.instantiateViewController(withIdentifier: "EventOrgSettings") {
            print("Successfully instantiated EventOrgSettingsTableViewController")
            
            settingsVC.modalPresentationStyle = .fullScreen
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                if let navigationController = self.navigationController {
                    navigationController.pushViewController(settingsVC, animated: true)
                } else {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let window = windowScene.windows.first else {
                        print("Failed to access app window")
                        return
                    }
                    let navigationController = UINavigationController(rootViewController: settingsVC)
                    window.rootViewController = navigationController
                    window.makeKeyAndVisible()
                }
            }
        } else {
            print("Failed to instantiate EventOrgSettingsTableViewController. Check storyboard ID.")
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Login Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

