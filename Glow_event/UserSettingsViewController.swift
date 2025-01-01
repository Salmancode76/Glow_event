import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UserSettingsViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    
    var settings = ["Profile", "My Interests", "My Tickets", "Notifications", "My Events", "View Highlights", "Change Password", "Sign Out"]
        var filteredSettings = [String]()

        override func viewDidLoad() {
            super.viewDidLoad()

            searchBar.delegate = self
            filteredSettings = settings

            notificationsSwitch.isOn = false
            
            if let textField = searchBar.searchTextField as? UITextField {
                textField.textColor = .white
            }
        }

    // MARK: - SearchBar Delegate Methods
            func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                updateTableVisibility(for: searchText)
            }

        private func updateTableVisibility(for searchText: String) {
            let normalizedSearchText = searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

            var matchedIndex: IndexPath? = nil
            for (index, setting) in settings.enumerated() {
                let normalizedSetting = setting.lowercased()
                let indexPath = IndexPath(row: index, section: 0)
                let cell = tableView.cellForRow(at: indexPath)

                if normalizedSearchText.isEmpty {
                    cell?.isHidden = false
                } else if normalizedSetting.contains(normalizedSearchText) {
                    matchedIndex = indexPath
                } else {
                    cell?.isHidden = true
                }
            }

            if let matchedIndex = matchedIndex {
                for section in 0..<tableView.numberOfSections {
                    for row in 0..<tableView.numberOfRows(inSection: section) {
                        let indexPath = IndexPath(row: row, section: section)
                        let cell = tableView.cellForRow(at: indexPath)
                        cell?.isHidden = indexPath != matchedIndex
                    }
                }
            } else {
                for section in 0..<tableView.numberOfSections {
                    for row in 0..<tableView.numberOfRows(inSection: section) {
                        let indexPath = IndexPath(row: row, section: section)
                        let cell = tableView.cellForRow(at: indexPath)
                        cell?.isHidden = false
                    }
                }
            }
        }

            // MARK: - TableView Delegate Methods
            override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let selectedSetting = settings[indexPath.row]

                switch selectedSetting {
                case "Profile":
                    print("Navigating to Profile")
                    // Navigate to Profile
                case "My Interests":
                    print("Navigating to My Interests")
                    // Navigate to My Interests
                case "My Tickets":
                    print("Navigating to My Tickets")
                    // Navigate to My Tickets
                case "Notifications":
                    notificationsSwitch.setOn(!notificationsSwitch.isOn, animated: true)
                    notificationsSwitchChanged(notificationsSwitch)
                case "My Events":
                    print("Navigating to My Events")
                    // Navigate to My Events
                case "View Highlights":
                    print("Navigating to View Highlights")
                    // Navigate to View Highlights
                case "Change Password":
                    print("Navigating to Change Password")
                    // Navigate to Change Password
                case "Sign Out":
                    showSignOutAlert()
                default:
                    break
                }

                tableView.deselectRow(at: indexPath, animated: true)
            }
        // MARK: - Switch Action Methods
        @IBAction func notificationsSwitchChanged(_ sender: UISwitch) {
            if sender.isOn {
                print("Notifications enabled")
            } else {
                print("Notifications disabled")
            }
        }


        // MARK: - Sign Out and Delete Account
        private func signOutUser() {
            do {
                try Auth.auth().signOut()
                print("User signed out successfully")
                navigateToLogin()
            } catch let error {
                print("Error signing out: \(error.localizedDescription)")
            }
        }

        // MARK: - Alerts
        private func showSignOutAlert() {
            let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
                self.signOutUser()
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
