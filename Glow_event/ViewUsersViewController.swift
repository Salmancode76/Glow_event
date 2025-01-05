import Firebase
import FirebaseAuth
import FirebaseDatabase
import UIKit

class ViewUsersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var users: [[String: Any]] = []
        var filteredUsers: [[String: Any]] = []
        var isSearching = false
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Set the table view's delegate and data source
            tableView.delegate = self
            tableView.dataSource = self
            
            // Set the search bar delegate
            searchBar.delegate = self
            
            // Fetch users from Firebase
            fetchUsersFromFirebase()
            
            tableView.isScrollEnabled = true
            tableView.alwaysBounceVertical = true
        }
        
    func fetchUsersFromFirebase() {
        let databaseRef = Database.database().reference().child("users")
        
        databaseRef.observeSingleEvent(of: .value) { snapshot in
            guard let userDict = snapshot.value as? [String: [String: Any]] else {
                print("Error: Failed to fetch users")
                return
            }
            
            // Map the users into the local array
            self.users = userDict.map { (key, value) -> [String: Any] in
                var userData = value
                userData["uid"] = key // Include the UID in the user's data
                
                // Default to "Unknown User" if the name field is missing or empty
                if let name = userData["name"] as? String, !name.isEmpty {
                    userData["name"] = name
                } else {
                    userData["name"] = "Unknown User"
                }
                
                return userData
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } withCancel: { error in
            print("Error fetching users: \(error.localizedDescription)")
        }
    }
    }

    extension ViewUsersViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return isSearching ? filteredUsers.count : users.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell else {
                fatalError("Failed to dequeue UserCell")
            }
            
            let user = isSearching ? filteredUsers[indexPath.row] : users[indexPath.row]
            
            cell.nameLabel.text = user["name"] as? String ?? "Unknown User"
            
            if let profileImageUrl = user["profileImageUrl"] as? String, let url = URL(string: profileImageUrl) {
                URLSession.shared.dataTask(with: url) { data, _, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.profileImageView.image = image
                            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.width / 2
                            cell.profileImageView.clipsToBounds = true
                        }
                    }
                }.resume()
            } else {
                cell.profileImageView.image = UIImage(systemName: "person.circle")
            }
            
            return cell
        }
    }

    extension ViewUsersViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
    }

    extension ViewUsersViewController: UISearchBarDelegate {
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText.isEmpty {
                isSearching = false
                filteredUsers.removeAll()
            } else {
                isSearching = true
                filteredUsers = users.filter { user in
                    if let name = user["name"] as? String {
                        return name.lowercased().contains(searchText.lowercased())
                    }
                    return false
                }
            }
            tableView.reloadData()
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.text = ""
            isSearching = false
            filteredUsers.removeAll()
            tableView.reloadData()
            searchBar.resignFirstResponder()
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ShowUserDetail",
               let destinationVC = segue.destination as? UserDetailViewController,
               let indexPath = tableView.indexPathForSelectedRow {
                
                // pass the selected user's data
                let selectedUser = isSearching ? filteredUsers[indexPath.row] : users[indexPath.row]
                destinationVC.user = selectedUser
            }
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            fetchUsersFromFirebase()
        }
    }
