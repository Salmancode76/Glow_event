//
//  EditEventTableViewController.swift
//  Glow_event
//
//  Created by BP-36-201-17 on 21/12/2024.
//

import UIKit
import SwiftUI


class AdminEditEventTableViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var EditName: UITextField!

    @IBOutlet weak var EventStartDate: UIDatePicker!
    @IBOutlet weak var EventDate: UIDatePicker!
    
    @IBOutlet weak var EditPrice: UITextField!
    @IBOutlet weak var EditCategory: UIButton!
    @IBOutlet weak var EditLocation: UIButton!
    @IBOutlet weak var EditAgeGrp: UIButton!
    @IBOutlet weak var EventDes: UITextView!
    @IBOutlet weak var EditStatus: UIButton!
    @IBOutlet weak var EditCap: UITextField!
    @IBOutlet weak var EditImage: UIImageView!
    var eventName: String = ""
    var eventUrl : String = ""
    var eventPrice :Double = 0
    var eventCap :Int = 0
    var eventLocation :String = ""
    var eventCategory : String = ""
    var eventAge : String = ""
    var eventDes : String = ""
    var eventStatus : String = ""
    var eventStartDate : Date = Date.now
    var eventEndDate : Date = Date.now

    var eventID : String = ""
    var selectedImage: UIImage?
    
    let cloudinary = CloudinarySetup.cloudinarySetup()


    
    @IBAction func optionSelectionEventCategory(_ sender:UIAction)
    {
        self.EditCategory.setTitle(sender.title, for: .normal)

    }
    
    
    @IBAction func optionSelection(_ sender:UIAction)
    {
        self.EditLocation.setTitle(sender.title, for: .normal)
    }
     
    @IBAction func optionAgeGroup(_ sender:UIAction){
        
        self.EditAgeGrp.setTitle(sender.title, for: .normal)

    }
    
    @IBAction func optionSelectionEventStatus(_ sender:UIAction)
    {
        self.EditStatus.setTitle(sender.title, for: .normal)
    }
    
    
    // Delegate method that is called after an image is selected or a photo is taken
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           if let selectedImage = info[.originalImage] as? UIImage {
               self.selectedImage = selectedImage
               
               DispatchQueue.main.async {
                   self.EditImage.image = selectedImage
               }
           }
           picker.dismiss(animated: true, completion: nil)
       }
    
    

       @IBAction func eventPhotoButtonTapped(_ sender: UIButton) {
           let imagePickerController = UIImagePickerController()
           imagePickerController.delegate = self
           imagePickerController.sourceType = .photoLibrary
           imagePickerController.allowsEditing = true
           
           // Present the image picker controller
           present(imagePickerController, animated: true, completion: nil)
       }
    
    @IBAction func Update_Event(_ sender: Any) {
        // Validate Event Name
            guard let eventName = EditName.text, !eventName.isEmpty else {
                showErrorAlert(errorMessage: "Event Name is required.")
                return
            }

            // Validate Event Price (must be a positive number)
            guard let eventPriceText = EditPrice.text, let eventPrice = Double(eventPriceText), eventPrice > 0 else {
                showErrorAlert(errorMessage: "Please enter a valid Event Price.")
                return
            }

            // Validate Event Capacity (must be a positive integer)
            guard let eventCapText = EditCap.text, let eventCap = Int(eventCapText), eventCap > 0 else {
                showErrorAlert(errorMessage: "Please enter a valid Event Capacity.")
                return
            }

            // Validate Event Description
            guard let eventDescription = EventDes.text, !eventDescription.isEmpty else {
                showErrorAlert(errorMessage: "Event Description is required.")
                return
            }

        guard let eventCapText = EditCap.text, let eventCap = Int(eventCapText), eventCap > 0 else {
            showErrorAlert(errorMessage: "Please enter a valid Event Capacity.")
            return
        }

            // Validate Event Category (must not be empty or default value)
            guard let selectedCategory = EditCategory.title(for: .normal), selectedCategory != "Category" else {
                showErrorAlert(errorMessage: "Event Category is required.")
                return
            }

            // Validate Event Location (must not be empty or default value)
            guard let selectedLocation = EditLocation.title(for: .normal), selectedLocation != "Location" else {
                showErrorAlert(errorMessage: "Event Location is required.")
                return
            }

            // Validate Age Group (must not be empty or default value)
            guard let selectedAgeGroup = EditAgeGrp.title(for: .normal), selectedAgeGroup != "Age Group" else {
                showErrorAlert(errorMessage: "Age Group is required.")
                return
            }

            // Validate Event Status (must not be empty or default value)
            guard let selectedStatus = EditStatus.title(for: .normal), selectedStatus != "Status" else {
                showErrorAlert(errorMessage: "Event Status is required.")
                return
            }

            // Validate Start and End Dates
            let startDateTimestamp = EventStartDate.date.timeIntervalSince1970
            let endDateTimestamp = EventDate.date.timeIntervalSince1970

            // Ensure Start Date is before End Date
            guard startDateTimestamp <= endDateTimestamp else {
                showErrorAlert(errorMessage: "Start Date cannot be after End Date.")
                return
            }


        // Check if an image is selected or use a default image
        let eventImage = selectedImage ?? UIImage(named: "defaultImage") ?? UIImage()

        if selectedImage != nil {
            uploadImage(eventImage) { [weak self] uploadedUrl in
                guard let self = self else { return }
                if let url = uploadedUrl {
                    // Update the event with the new image URL
                    self.eventUrl = url
                    self.updateEventInDatabase(startDateTimestamp: startDateTimestamp, endDateTimestamp: endDateTimestamp)
                } else {
                    // Handle image upload failure
                    showErrorAlert(errorMessage: "Error uploading image.")
                }
            }
        } else {
            self.updateEventInDatabase(startDateTimestamp: startDateTimestamp, endDateTimestamp: endDateTimestamp)
        }
    }

    // Upload the event image to Cloudinary and get the URL
    private func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        CloudinarySetup.uploadeEventImage(image: image) { uploadedUrl in
            completion(uploadedUrl)
        }
    }

    // Update the event data in Firebase
    private func updateEventInDatabase(startDateTimestamp: TimeInterval, endDateTimestamp: TimeInterval) {
        // Prepare the event data dictionary
        let updatedData: [String: Any] = [
            "EventName": EditName.text ?? "",
            "startDate": startDateTimestamp,
            "endDate": endDateTimestamp,
            "price": Double(EditPrice.text ?? "") ?? 0.0,
            "EventCategory": EditCategory.title(for: .normal) ?? "",
            "venue_options": EditLocation.title(for: .normal) ?? "",
            "AgeGroup": EditAgeGrp.title(for: .normal) ?? "",
            "description": EventDes.text ?? "",
            "EventStatus": EditStatus.title(for: .normal) ?? "",
            "Capacity": Int(EditCap.text ?? "") as Any,
            "EventImg": self.eventUrl // This is the updated image URL
        ]
        
        FirebaseDB.updateEvent(eventID: self.eventID, updatedData: updatedData) { success, error in
            if success {
                self.showSuccessAlert()

                
            } else {
                self.showErrorAlert(errorMessage: "ERROR IN THE DATABASE CONTACT SUPPORT NOW!")
            }
        }
    }

    private func showSuccessAlert() {
        let alertController = UIAlertController(title: "Success", message: "The event has been updated successfully.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let navigationController = self.navigationController {
//                if let homeViewController = navigationController.viewControllers.first(where: { $0 is AdminHomeOrgViewController }) {
//                    navigationController.popToViewController(homeViewController, animated: true)
//                }
            }
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    private func showErrorAlert(errorMessage: String) {
        // Create an alert controller with a title and message indicating failure
        let alertController = UIAlertController(title: "Failure", message: "Failed to update the event. Error: \(errorMessage)", preferredStyle: .alert)
        
        // Add an OK button to dismiss the alert
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        
        
        // Present the alert
        self.present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .singleLine
        
        tableView.separatorColor = UIColor.lightGray 
        
        
        EditCategory.setTitle(eventCategory, for: .normal) 
        EditName.text = eventName
        
        EditPrice.text = String(eventPrice)
        EditLocation.setTitle(eventLocation, for: .normal)
        
        EditCap.text = String(eventCap)
        
        EditAgeGrp.setTitle(eventAge, for: .normal)

        EventDes.text = eventDes
        
        EditStatus.setTitle(eventStatus, for: .normal)
        EventStartDate.tintColor = UIColor.white
       
        EventStartDate.date = eventStartDate
        
        EventDate.date = eventEndDate
            
        EventDate.tintColor = UIColor.white
        if #available(iOS 14.0, *) {
            EventStartDate.setValue(UIColor.white, forKeyPath: "textColor")
            EventDate.setValue(UIColor.white, forKeyPath: "textColor")
        }
        
        
        if URL(string: eventUrl) != nil {
            CloudinarySetup.DownloadEventyImage(from: eventUrl) { image in
                DispatchQueue.main.async {
                    self.EditImage.image = image
                }
            }
        } else {
            EditImage.image = UIImage(systemName: "photo.fill")
        }

    }



    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        // Set the background color of the header to white
        header.contentView.backgroundColor = .black
        
        // Set the text color of the header to black
        header.textLabel?.textColor = .white
        
        tableView.tableFooterView = UIView()
        
        
        
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 12
        
        
        
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0  // Set the footer height to 0 to hide the footer
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    



}
