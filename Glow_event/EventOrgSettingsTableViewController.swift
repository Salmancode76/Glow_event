import Firebase
import FirebaseAuth
import UIKit

class EventOrgSettingsTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var settings = ["Profile", "Saved Events", "View Event Highlights", "Sign Out"]
    var filteredSettings = [String]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        filteredSettings = settings
        
        if let textField = searchBar.searchTextField as? UITextField {
            textField.textColor = .white
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            updateTableVisibility(for: searchText)
        }
            
        private func updateTableVisibility(for searchText: String) {
            // Normalize search text for comparison (lowercased and trimmed)
            let normalizedSearchText = searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            
            let allCells = [
                tableView.cellForRow(at: IndexPath(row: 0, section: 0)), // Profile
                tableView.cellForRow(at: IndexPath(row: 0, section: 1)), // Change Password
                tableView.cellForRow(at: IndexPath(row: 1, section: 1))  // Sign Out
            ]

            for (index, cell) in allCells.enumerated() {
                if let cell = cell {
                    // Normalize the setting name for comparison
                    let normalizedSetting = settings[index].lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if normalizedSearchText.isEmpty || normalizedSetting.contains(normalizedSearchText) {
                        cell.isHidden = false
                    } else {
                        cell.isHidden = true
                    }
                }
            }
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedSetting = settings[indexPath.row]
            
            switch selectedSetting {
            case "Sign Out":
                showSignOutAlert()
            case "Profile":
                // Handle profile navigation
                break
            case "Change Password":
                // Handle password change
                break
            default:
                break
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
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
        guard let loginVC = storyboard?.instantiateViewController(withIdentifier: "EventOrgLoginViewController") else { return }
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
