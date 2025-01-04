//
//  ViewController.swift
//  Glow_event
//
//  Created by BP-36-201-09 on 25/11/2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Navigate to SignupViewController
            let signupVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            self.navigationController?.pushViewController(signupVC, animated: true)
        }
   }
}

