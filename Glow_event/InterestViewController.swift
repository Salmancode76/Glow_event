//
//  InterestViewController.swift
//  Glow_event
//
//  Created by PRINTANICA on 03/01/2025.
//

import UIKit
import Firebase

class InterestViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var categories: [String] = [] // This will be populated with your categories from Firebase
       var selectedCategories: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchCategories()

        // Do any additional setup after loading the view.
    }
    
    
    func fetchCategories() {
           let ref = Database.database().reference().child("events")
           ref.observeSingleEvent(of: .value) { snapshot in
               var categoriesSet: Set<String> = []

               for child in snapshot.children {
                   if let childSnapshot = child as? DataSnapshot,
                      let eventData = childSnapshot.value as? [String: Any],
                      let category = eventData["EventCategory"] as? String {
                       categoriesSet.insert(category)
                   }
               }

               self.categories = Array(categoriesSet) // Convert Set to Array
               self.tableView.reloadData() // Refresh table view
           }
       }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count // Return the number of categories
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row] // Set the text to the category name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]

            if selectedCategories.contains(selectedCategory) {
                // Remove the category if it's already selected
                selectedCategories.removeAll { $0 == selectedCategory }
            } else {
                // Add the category if it's not already selected
                selectedCategories.append(selectedCategory)
            }

            // Reload the specific row to update the UI
            tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    
    
    @IBAction func Save(_ sender: Any) {
        
        performSegue(withIdentifier: "toUserHome", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserHome", let homeVC = segue.destination as? UserHome {
            // Pass selected categories to the User Home View Controller
            homeVC.selectedCategories = selectedCategories
        }
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
