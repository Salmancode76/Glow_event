import Firebase
import FirebaseAuth
import FirebaseDatabase
import UIKit

class AdminLoginViewController: UIViewController {
    
    
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
                    
                    // Use Firebase Authentication to validate the credentials
                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            // Log and display error if sign-in fails
                            print("Firebase sign-in error: \(error.localizedDescription)")
                            self.showErrorAlert(message: error.localizedDescription)
                            return
                        }
                        
                        // Successfully signed in
                        if let user = authResult?.user {
                            print("Sign-in successful. User ID: \(user.uid), Email: \(user.email ?? "No Email")")
                            self.navigateToTabBar()
                        } else {
                            print("Unexpected error: User is nil.")
                            self.showErrorAlert(message: "An unexpected error occurred. Please try again.")
                        }
                    }
                    }
                    
    private func navigateToTabBar() {
        print("Attempting to navigate to TabBar")
        
        if let tabBarVC = storyboard?.instantiateViewController(withIdentifier: "TabBar") as? UITabBarController {
            print("Successfully instantiated TabBarController")
            
            tabBarVC.modalPresentationStyle = .fullScreen
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController = tabBarVC
                    window.makeKeyAndVisible()
                } else {
                    print("Failed to access the app window")
                }
            }
        } else {
            print("Failed to instantiate TabBarController. Check storyboard ID.")
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
