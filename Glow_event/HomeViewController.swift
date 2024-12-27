//
//  HomeViewController.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 25/12/2024.
//

import SwiftUI

class HomeViewController: UIViewController {
    var userType: UserType?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigateToHomeViewController()
        }
    
    private func navigateToHomeViewController() {
            guard let userType = userType else {
                print("User  type is not set.")
                return
            }
    
            switch userType {
            case .admin:
                navigateToAdminHomeViewController()
            case .eventOrganizer:
                navigateToEventOrganizerHomeViewController()
            case .user1:
                navigateToUserHomeViewController()
            }
        }
    
        // Function to navigate to AdminHomeViewController
        private func navigateToAdminHomeViewController() {
            let adminHomeVC = storyboard?.instantiateViewController(withIdentifier: "adminHomeVC") as! AdminHomeViewController
            navigationController?.pushViewController(adminHomeVC, animated: true)
        }
    
        // Function to navigate to EventOrganizerHomeViewController
        private func navigateToEventOrganizerHomeViewController() {
            let eventOrganizerHomeVC = storyboard?.instantiateViewController(withIdentifier: "eventOrganizerHomeVC") as! EventOrganizerHomeViewController
            navigationController?.pushViewController(eventOrganizerHomeVC, animated: true)
        }
    
        // Function to navigate to UserHomeViewController
        private func navigateToUserHomeViewController() {
            let userHomeVC = storyboard?.instantiateViewController(withIdentifier: "userHomeVC") as! UserHomeViewController
            navigationController?.pushViewController(userHomeVC, animated: true)
        }
}
