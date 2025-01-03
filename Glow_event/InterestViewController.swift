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
       var selectedCategories: Set<String> = []
    
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        if selectedCategories.contains(selectedCategory) {
            selectedCategories.remove(selectedCategory)
        } else {
            selectedCategories.insert(selectedCategory)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic) // Refresh the row to show/hide the circle
    }
    
    
    
    
    @IBAction func Save(_ sender: Any) {
        
        print("Selected Categories: \(selectedCategories)")
            
            // Navigate to the Home Screen (implementation may vary)
            let homeVC = storyboard?.instantiateViewController(withIdentifier: "UserHomeController") as! UserHome
            homeVC.selectedCategories = Array(selectedCategories) // Pass selected categories
            navigationController?.pushViewController(homeVC, animated: true)
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
