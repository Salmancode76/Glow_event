//
//  HomeTabVC.swift
//  EventApp
//
//  Created by Ramesh Sanghar on 28/12/24.
//

import UIKit

class HomeTabVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Update the title of the TabBarVC
        if let tabBarVC = self.tabBarController as? TabBarVC {
            tabBarVC.title = "Home"
        }
    }
    
}
