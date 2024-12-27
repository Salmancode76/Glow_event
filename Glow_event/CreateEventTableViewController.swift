//
//  CreateEventTableViewController.swift
//  Glow_event
//
//  Created by BP-36-201-09 on 07/12/2024.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import Cloudinary

class CreateEventTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var EventCategory: UIButton!
    @IBOutlet weak var AgeGroupbtn: UIButton!
    
    @IBOutlet weak var EventCaptxt: UITextField!
    
    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var eventstatus: UIButton!
    
    @IBOutlet weak var priceLbl: UITextField!
    @IBOutlet weak var venu_options: UIButton!
    @IBOutlet weak var startpicker: UIDatePicker!
    @IBOutlet weak var endpicker: UIDatePicker!
    @IBOutlet weak var event_photo: UIButton!
    
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var EventNameLbl: UITextField!
    
    @IBOutlet weak var decriptionLbl: UITextView!
    
    @IBOutlet weak var endDate: UIDatePicker!
    @IBOutlet weak var event_status: UIButton!
    
    @IBOutlet weak var EventPhoto: UIButton!
    var selectedEventImage: UIImage?
    var Eventurl = "nil"
    
    var eventData: [String: Any] = [:]
    
    let cloudinary = CloudinarySetup.cloudinarySetup()
    
    
    
    
    @IBOutlet var CreateEventTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true

        
        imageview.image = UIImage(systemName: "photo.fill")
        // Change the background color of the table view
        CreateEventTable.backgroundColor = UIColor.black // Or any color you prefer
        
        // Optional: Set the table view's separator color (if needed)
        CreateEventTable.separatorColor = UIColor.white
        
        startDate.backgroundColor = UIColor.black
        
        
        endpicker.backgroundColor = UIColor.black
        
        
        startDate.tintColor = UIColor.white
        endpicker.tintColor = UIColor.black
        
        
        // 3. For iOS 14+, change the text color of the UIDatePicker elements (e.g. day, month, year)
        if #available(iOS 14.0, *) {
            startDate.setValue(UIColor.white, forKeyPath: "textColor")
            endpicker.setValue(UIColor.white, forKeyPath: "textColor")
        }
        
        startDate.alpha = 1.0
        endpicker.alpha = 1.0
        
        
        // 2. Set the text color (and other UI elements) to white using tintColor
        startDate.tintColor = UIColor.white
        endpicker.tintColor = UIColor.black
        
    }
    
    // MARK: - TableView Delegate Method to Customize Header Appearance
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        header.contentView.backgroundColor = .black
        
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
        return 1
    }
    
    
    
    
    
    // @IBOutlet weak var scrollView: UIScrollView!

    
    
    // This function is triggered when the "Event Photo" button is tapped
    @IBAction func eventPhotoButtonTapped(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary  // Allow the user to pick a photo from the photo library
        imagePickerController.allowsEditing = true        // Optional: Allow editing of the photo (e.g., cropping)
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // Delegate method that is called after an image is selected or a photo is taken
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.originalImage] as? UIImage {
            //  uploadImage(image: selectedImage)
            
            // Store the selected image in the variable
            selectedEventImage = selectedImage
            
            // Update the imageview with the selected image
            DispatchQueue.main.async {
                self.imageview.image = selectedImage
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    
    // Delegate method that is called if the user cancels the image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    

    
    
    
    @IBAction func optionCategory(_ sender:UIAction)
    {
        self.venu_options.setTitle(sender.title, for: .normal)
    }
   
    
   
    
    

    
    
    @IBAction func optionAgeGroup(_ sender:UIAction){
        
        self.AgeGroupbtn.setTitle(sender.title, for: .normal)

    }
    @IBAction func optionSelection(_ sender:UIAction)
    {
        self.venu_options.setTitle(sender.title, for: .normal)
    }
     
    @IBAction func optionSelectionEventStatus(_ sender:UIAction)
    {
        self.event_status.setTitle(sender.title, for: .normal)
    }
     
    @IBOutlet weak var category: UIButton!
    @IBAction func optionSelectionEventCategory(_ sender:UIAction)
    {
        
        self.EventCategory.setTitle(sender.title, for: .normal)
    }
 

    
    
    
    // Create event action
    @IBAction func CreateEvent(_ sender: Any) {
        
        guard let SelectedCategory = self.EventCategory.title(for: .normal),
              !SelectedCategory.isEmpty,
              SelectedCategory != "Category" else {
            showErrorAlert(message: "Event Category is not selected.")
            return
        }

        
        guard let eventName = EventNameLbl.text, !eventName.isEmpty else {
            showErrorAlert(message: "Invalid Event Name Data")
            return
        }
        guard let  eventcap = EventCaptxt.text , !eventcap.isEmpty  else {
            showErrorAlert(message:"Invalid Event Capcity Data")
            return
        }
        guard let eventcap = Int(eventcap) else {
            showErrorAlert(message:"Invalid Capcity format.")
            return
        }
      
        guard let selectedVenue = self.venu_options.title(for: .normal), !selectedVenue.isEmpty, selectedVenue != "Venus" else {
            showErrorAlert(message: "Venue is not selected or is invalid.")
            return
        }
        guard let selectedAgeGroup = self.AgeGroupbtn.title(for: .normal), !selectedAgeGroup.isEmpty , selectedAgeGroup != "Age Group" else {
            showErrorAlert(message:"Age group is not Selected.")
            return
        }
        guard let enteredPriceText = priceLbl.text, !enteredPriceText.isEmpty else {
            showErrorAlert(message:"Price is empty.")
            return
        }
        
        
        guard let enteredPrice = Double(enteredPriceText) else {
            showErrorAlert(message:"Invalid price format.")
            return
        }
        guard let eventdesc = decriptionLbl.text, !eventdesc.isEmpty else {
            showErrorAlert(message:"Event description is empty.")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let startDateValue = startDate.date  // Getting Date from UIDatePicker
        
        let endDateValue = endDate.date
        
        
        
        
        guard let selectedStatus = self.event_status.title(for: .normal), !selectedStatus.isEmpty, selectedStatus != "Event status"  else {
            showErrorAlert(message:"Event Status is not selected.")
            return
        }
        
        
     
        // Check if the selected event image is available
        guard let eventImage = selectedEventImage else {
            showErrorAlert(message:"No event image selected.")
            return
        }

  

        // eventImage = selectedEventImage ?? UIImage(named: "defaultImage")!
        
        
        // Upload the image and handle the completion
        CloudinarySetup.uploadeEventImage(image: eventImage) { [weak self] uploadedUrl in
            guard let self = self else { return }
            
            if let url = uploadedUrl {
                // Assign the uploaded URL to Eventurl
                self.Eventurl = url
                
           
                
                let eventData: [String: Any] = [
                    "EventName": eventName,
                    "venue_options": selectedVenue,
                    "price": enteredPrice,
                    "startDate": startDateValue.timeIntervalSince1970, // Firebase stores time as timestamp
                    "endDate": endDateValue.timeIntervalSince1970,
                    "description": eventdesc,
                    "EventStatus": selectedStatus,
                    "EventImg": self.Eventurl ,
                    "EventCategory": SelectedCategory,
                    "AgeGroup":selectedAgeGroup,
                    "Capcity": eventcap
                    

                ]
                
           
                
                FirebaseDB.saveEventData(eventData: eventData) { success, errorMessage in
                    if success {
                        self.showSuccessAlert()

                    } else {
                        self.showErrorAlert(message:"Error saving event")
                    }
                }
            }
        }
        
    }
    private func showSuccessAlert() {
        let alertController = UIAlertController(title: "Success", message: "The event has been created successfully.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let navigationController = self.navigationController {
                if let homeViewController = navigationController.viewControllers.first(where: { $0 is HomeOrgViewController }) {
                    navigationController.popToViewController(homeViewController, animated: true)
                }
            }
        }
        
        // Add the "OK" action to the alert
        alertController.addAction(okAction)
        
        // Present the alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            
        }
        
        alertController.addAction(okAction)
        
        // Present the error alert
        self.present(alertController, animated: true, completion: nil)
    }

    
    
    
    
}
    
