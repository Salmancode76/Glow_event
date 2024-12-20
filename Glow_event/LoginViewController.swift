import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showErrorAlert(message: "Please enter both email and password.")
            return
        }
        
        print("Attempting to sign in with email: \(email)")
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Firebase sign-in error: \(error.localizedDescription)")
                self.showErrorAlert(message: error.localizedDescription)
                return
            }
            
            print("Sign-in successful. User ID: \(authResult?.user.uid ?? "Unknown UID")")
            self.navigateToProfileScreen()
        }
    }
    
    private func navigateToProfileScreen() {
        print("Attempting to navigate to UserProfileViewController")
        
        if let profileVC = storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") {
            print("Successfully instantiated UserProfileViewController")
            
            profileVC.modalPresentationStyle = .fullScreen
            
            DispatchQueue.main.async { [weak self] in
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let window = windowScene.windows.first else {
                    print("Failed to access app window")
                    return
                }
                
                // Set the profile screen as the root view controller
                let navigationController = UINavigationController(rootViewController: profileVC)
                window.rootViewController = navigationController
                window.makeKeyAndVisible()
            }
        } else {
            print("Failed to instantiate UserProfileViewController. Check storyboard ID.")
        }
    }
    
    private func showErrorAlert(message: String) {
            let alert = UIAlertController(title: "Login Error", message: message, preferredStyle: .alert)
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
