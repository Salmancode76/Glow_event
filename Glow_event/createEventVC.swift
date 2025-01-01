//
//  createEventVC.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 28/12/2024.
//

import SwiftUI
import UIKit

class createEventVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Main Screen"

        let createEventButton = UIButton(type: .system)
        createEventButton.setTitle("Create Event", for: .normal)
        createEventButton.addTarget(self, action: #selector(presentCreateEventScreen), for: .touchUpInside)
        createEventButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(createEventButton)

        // Layout Constraints
        NSLayoutConstraint
            .activate([
            createEventButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createEventButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func presentCreateEventScreen() {
        let createEventVC = CreateEventViewController()
        navigationController?.pushViewController(createEventVC, animated: true)
    }
}
