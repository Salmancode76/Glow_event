import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UserSettingsViewController: UITableViewController {

    
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var lightModeSwitch: UISwitch!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            notificationsSwitch.isOn = false
            lightModeSwitch.isOn = false
        }

    @IBAction func notificationsSwitchChanged(_ sender: UISwitch) {
            if sender.isOn {
                print("Notifications enabled")
            } else {
                print("Notifications disabled")
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
                case 2:
                    showDeleteAccountAlert()
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
    
    private func deleteUserAccount() {
        guard let user = Auth.auth().currentUser else {
            print("No user is logged in")
            return
        }

        let uid = user.uid

        let databaseRef = Database.database().reference().child("users").child(uid)
        databaseRef.removeValue { error, _ in
            if let error = error {
                print("Error removing user data: \(error.localizedDescription)")
                self.showAlert(title: "Error", message: "Failed to remove user data. Please try again.")
                return
            } else {
                print("User data successfully removed from the database.")

                user.delete { error in
                    if let error = error {
                        print("Error deleting user account: \(error.localizedDescription)")
                        self.showAlert(title: "Error", message: "Failed to delete account. Please try again.")
                    } else {
                        print("User account deleted successfully.")
                        self.navigateToLogin()
                    }
                }
            }
        }
    }
    
    private func removeUserFromDatabase() {
            guard let user = Auth.auth().currentUser else { return }
            let uid = user.uid
            let databaseRef = Database.database().reference().child("users").child(uid)
            databaseRef.removeValue { error, _ in
                if let error = error {
                    print("Error removing user data: \(error.localizedDescription)")
                } else {
                    print("User data removed from database")
                }
            }
        }
    
    func deleteAccount() {
            guard let user = Auth.auth().currentUser else { return }
            user.delete { error in
                if let error = error {
                    print("Error deleting account: \(error.localizedDescription)")
                } else {
                    print("Account deleted successfully")
                }
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
    
    private func showDeleteAccountAlert() {
            let alert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account? This action cannot be undone.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
                self.deleteUserAccount()
            }))
            present(alert, animated: true, completion: nil)
        }
    
    private func navigateToLogin() {
            guard let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") else { return }
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true, completion: nil)
        }
    
    func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
}
