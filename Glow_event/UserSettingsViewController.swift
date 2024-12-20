import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UserSettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // set delegate and datasource properties
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deselect the cell after the user taps it
        tableView.deselectRow(at: indexPath, animated: true)
        
        // check uf the tapped cell is the "Delete Account" cell
        if indexPath.section == 2 && indexPath.row == 0 {
            showDeleteAccountConfirmation()
        }
    }
    
    func showDeleteAccountConfirmation() {
        let alert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account? This action cannot be undone.", preferredStyle: .alert)
        
        // Add cancel action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Add delete action
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteUserAccount { success, errorMessage in
                if success {
                    self.showSuccessAlert()
                } else if let errorMessage = errorMessage {
                    self.showErrorAlert(message: errorMessage)
                }
            }
        }))
        
        // present the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteUserAccount(completion: @escaping (Bool, String?) -> Void) {
        // get the current user
        guard let user = Auth.auth().currentUser else {
            completion(false, "User not logged in.")
            return
        }
        
        // reference the user's data in firebase
        let uid = user.uid
        let databaseRef = Database.database().reference().child("users").child(uid)
        
        // remove the user's data from the database
        databaseRef.removeValue { error, _ in
            if let error = error {
                completion(false, "Failed to delete user data: \(error.localizedDescription)")
                return
            }
            
            // delete the user's account
            user.delete() { error in
                if let error = error {
                    completion(false, "Failed to delete user account: \(error.localizedDescription)")
                } else {
                    completion(true, nil)
                }
            }
        }
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Account Deleted", message: "Your account has been successfully deleted", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.redirectToLoginScreen()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func redirectToLoginScreen() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
    

}
