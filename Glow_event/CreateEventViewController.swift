//
//  CreateEventViewController.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 28/12/2024.
//
import UIKit

class CreateEventViewController: UIViewController {
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Event Title"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.systemGray6
        textField.textColor = UIColor.label
        textField.attributedPlaceholder = NSAttributedString(
            string: "Event Title",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]
        )
        return textField
    }()
    
    private let categoryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Event Category"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.systemGray6
        textField.textColor = UIColor.label
        textField.attributedPlaceholder = NSAttributedString(
            string: "Event Category",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]
        )
        return textField
    }()
    
    private let startTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.backgroundColor = UIColor.systemGray6
        picker.setValue(UIColor.label, forKey: "textColor")
        return picker
    }()
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Event", for: .normal)
        button.backgroundColor = UIColor.systemIndigo
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(createEventButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "Create Event"
        setupLayout()
    }
    
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [titleTextField, categoryTextField, startTimePicker, createButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func createEventButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty,
              let category = categoryTextField.text, !category.isEmpty else {
            showAlert(message: "Please enter valid title and category.")
            return
        }
        
        let startTime = startTimePicker.date
        EventManager.shared.createEvent(title: title, category: category, startTime: startTime) { success in
            if success {
                // Schedule a notification for the user if they are logged in and the event matches their preferences
                if let userId = GlobalUser.shared.currentUser?.uid {
                    NotificationManager.shared.scheduleLocalNotification(title: "Glow Event", body: "Check out the event: \(title)", date: startTime, userId: userId)
                }
                
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
                self.showAlert(message: "Error creating the event.")
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
