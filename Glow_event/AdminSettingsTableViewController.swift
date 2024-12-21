import Firebase
import FirebaseAuth
import FirebaseDatabase
import UIKit

class AdminSettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var lightModeSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        lightModeSwitch.isOn = false
        if let textField = searchBar.searchTextField as? UITextField {
                textField.textColor = .white
            }
    }
    
    @IBAction func lightModeSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            print("Light mode enabled")
        } else {
            print("Dark mode enabled")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if indexPath.section == 2 {
                switch indexPath.row {
                case 1:
                    showSignOutAlert()
                    signOutUser()
                default:
                    break
                }
            }
        }
    
    private func signOutUser() {
            do {
                try Auth.auth().signOut()
                print("User signed out successfully")
                // Navigate back to LoginViewController
                navigateToLogin()
            } catch let error {
                print("Error signing out: \(error.localizedDescription)")
            }
        }
    
    private func showSignOutAlert() {
            let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
                self.signOutUser()
            }))
            present(alert, animated: true, completion: nil)
        }
    
    private func navigateToLogin() {
            guard let loginVC = storyboard?.instantiateViewController(withIdentifier: "AdminLoginViewController") else { return }
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true, completion: nil)
        }
    
    func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }

}
