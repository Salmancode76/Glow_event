//
//  CategoriesViewController.swift
//  Glow_event
//
//  Created by PRINTANICA on 06/01/2025.
//

import UIKit
import FirebaseDatabase



class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
    
    
    

    @IBOutlet weak var tableview: UITableView!
    
    var categories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
                tableview.dataSource = self
                

        // Do any additional setup after loading the view.
    }
    
   
       
    
    

        // UITableViewDataSource
    
      
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        let selectedCategories = categories.filter { $0.isSelected }.map { $0.name }
                
                // Save selected categories to UserDefaults or Firebase
                UserDefaults.standard.set(selectedCategories, forKey: "SelectedCategories")
                
                // Navigate to Home Screen
                performSegue(withIdentifier: "HomeScreenSegue", sender: nil) // Update with your segue identifier
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
