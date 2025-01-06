import UIKit
import FirebaseDatabase
import FirebaseAuth

class CategoriesTableViewController: UITableViewController {

    var ref: DatabaseReference!
    var categories: [String] = []
    var selectedCategories: Set<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()

        fetchCategoriesAndUserInterests()
    }

    func fetchCategoriesAndUserInterests() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        ref.child("categories").observeSingleEvent(of: .value, with: { snapshot in
            if let value = snapshot.value as? [String: String] {
                self.categories = Array(value.values).sorted()

                self.ref.child("userInterests").child(userId).observeSingleEvent(of: .value, with: { userSnapshot in
                    if let userInterests = userSnapshot.value as? [String: Bool] {
                        self.selectedCategories = Set(userInterests.filter { $0.value }.map { $0.key })
                    } else {
                        var defaultInterests: [String: Bool] = [:]
                        for category in self.categories {
                            defaultInterests[category] = false
                        }
                        self.ref.child("userInterests").child(userId).setValue(defaultInterests)
                        self.selectedCategories = []
                    }
                    self.tableView.reloadData()
                })
            }
        }) { error in
            print("Error fetching data: \(error.localizedDescription)")
        }
    }
    
    @IBAction func saveInterests(_ sender: UIBarButtonItem) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

                var interestsUpdate: [String: Bool] = [:]
                for category in categories {
                    interestsUpdate[category] = selectedCategories.contains(category)
                }

                ref.child("userInterests").observeSingleEvent(of: .value) { snapshot in
                    if snapshot.hasChild(userId) {
                        self.ref.child("userInterests").child(userId).setValue(interestsUpdate) { error, _ in
                            if let error = error {
                                print("Error updating interests: \(error.localizedDescription)")
                            } else {
                                print("Interests updated successfully.")
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    } else {
                        self.ref.child("userInterests").child(userId).setValue(interestsUpdate) { error, _ in
                            if let error = error {
                                print("Error saving new user interests: \(error.localizedDescription)")
                            } else {
                                print("New user interests saved successfully.")
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }
            }

            override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return categories.count
            }

            override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
                let category = categories[indexPath.row]

                cell.textLabel?.text = category
                cell.accessoryType = selectedCategories.contains(category) ? .checkmark : .none

                return cell
            }

            override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let category = categories[indexPath.row]

                if selectedCategories.contains(category) {
                    selectedCategories.remove(category)
                } else {
                    selectedCategories.insert(category)
                }

                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
