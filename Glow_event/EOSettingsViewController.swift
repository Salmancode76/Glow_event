//import Firebase
//import FirebaseAuth
//import UIKit
//
//class EOSettingsViewController: UITableViewController, UISearchBarDelegate {
//    
//    @IBOutlet weak var searchBar: UISearchBar!
//    
//    let settings = ["Profile", "Saved Events", "View Event Highlights", "Sign Out"]
//    var filteredSettings = [String]()
//    var isSearching = false
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.title = "Settings"
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
//        searchBar.delegate = self
//        
//        filteredSettings = settings // Initially show all settings
//        
//        if let textField = searchBar.searchTextField as? UITextField {
//            textField.textColor = .white
//        }
//    }
//    
//    // MARK: - Table View Data Source
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return isSearching ? filteredSettings.count : settings.count
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
//        let setting = isSearching ? filteredSettings[indexPath.row] : settings[indexPath.row]
//        cell.textLabel?.text = setting
//        cell.textLabel?.textColor = .white // Adjust color for dark mode
//        return cell
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedSetting = isSearching ? filteredSettings[indexPath.row] : settings[indexPath.row]
//        
//        switch selectedSetting {
//        case "Profile":
//            navigateToProfile()
//        case "Saved Events":
//            navigateToSavedEvents()
//        case "View Event Highlights":
//            navigateToEventHighlights()
//        case "Sign Out":
//            showSignOutAlert()
//        default:
//            break
//        }
//        
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//    
//    // MARK: - Search Bar Delegate
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty {
//            isSearching = false
//            filteredSettings = settings
//        } else {
//            isSearching = true
//            filteredSettings = settings.filter { $0.lowercased().contains(searchText.lowercased()) }
//        }
//        tableView.reloadData()
//    }
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.text = ""
//        isSearching = false
//        filteredSettings = settings
//        tableView.reloadData()
//        searchBar.resignFirstResponder()
//    }
//    
//    // MARK: - Navigation Methods
//    
//    private func navigateToProfile() {
//        print("Navigating to Profile Screen")
//        // Implement Profile navigation logic
//    }
//    
//    private func navigateToSavedEvents() {
//        print("Navigating to Saved Events Screen")
//        // Implement Saved Events navigation logic
//    }
//    
//    private func navigateToEventHighlights() {
//        print("Navigating to Event Highlights Screen")
//        // Implement Event Highlights navigation logic
//    }
//    
//    // MARK: - Sign Out Logic
//    
//    private func showSignOutAlert() {
//        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
//            self.signOutUser()
//        }))
//        present(alert, animated: true, completion: nil)
//    }
//    
//    private func signOutUser() {
//        do {
//            try Auth.auth().signOut()
//            print("User signed out successfully")
//            navigateToLogin()
//        } catch let error {
//            print("Error signing out: \(error.localizedDescription)")
//        }
//    }
//    
//    private func navigateToLogin() {
//        guard let loginVC = storyboard?.instantiateViewController(withIdentifier: "EOLoginViewController") else { return }
//        loginVC.modalPresentationStyle = .fullScreen
//        present(loginVC, animated: true, completion: nil)
//    }
//}
