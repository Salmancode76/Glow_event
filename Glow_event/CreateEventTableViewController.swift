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
    @IBOutlet weak var imageview: UIImageView!
    
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
    // MARK: - Table view data source
    
    // MARK: - TableView Delegate Method to Customize Header Appearance
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
        return 9
        
        
        
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0  // Set the footer height to 0 to hide the footer
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    
    
    
    // @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBAction func venu_options(_ sender: Any) {
    }
    
    
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
        
        
        
        print(selectedEventImage)
    }
    
    
    // Delegate method that is called if the user cancels the image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    

    
    
    
    
    
    @IBAction func optionSelection(_ sender:UIAction)
    {
        print(sender.title)
        self.venu_options.setTitle(sender.title, for: .normal)
    }
    @IBAction func optionSelectionEventStatus(_ sender:UIAction)
    {
        print(sender.title)
        self.event_status.setTitle(sender.title, for: .normal)
    }
 

    
    
    
    // Create event action
    @IBAction func CreateEvent(_ sender: Any) {
        guard let eventName = EventNameLbl.text, !eventName.isEmpty else {
            print("Event name is empty.")
            return
        }
        guard let selectedVenue = self.venu_options.title(for: .normal), !selectedVenue.isEmpty else {
            print("Venue is not selected.")
            return
        }
        guard let enteredPriceText = priceLbl.text, !enteredPriceText.isEmpty else {
            print("Price is empty.")
            return
        }
        
        // Attempt to convert the entered string to a Double
        guard let enteredPrice = Double(enteredPriceText) else {
            print("Invalid price format.")
            return
        }
        guard let eventdesc = decriptionLbl.text, !eventdesc.isEmpty else {
            print("Event description is empty.")
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let startDateValue = startDate.date  // Getting Date from UIDatePicker
        
        let endDateValue = endDate.date
        
        
        
        
        guard let selectedStatus = self.event_status.title(for: .normal), !selectedStatus.isEmpty else {
            print("Venue is not selected.")
            return
        }
        let eventImage = selectedEventImage ?? UIImage(named: "defaultImage")! // Replace "defaultImage" with your actual default image name if needed
        
        
        // Upload the image and handle the completion
        CloudinarySetup.uploadeEventImage(image: eventImage) { [weak self] uploadedUrl in
            guard let self = self else { return }
            
            if let url = uploadedUrl {
                // Assign the uploaded URL to Eventurl
                self.Eventurl = url
                print("Event URL set: \(self.Eventurl)") // Check if the URL is set correctly
                
           
                
                let eventData: [String: Any] = [
                    "EventName": eventName,
                    "venue_options": selectedVenue,
                    "price": enteredPrice,
                    "startDate": startDateValue.timeIntervalSince1970, // Firebase stores time as timestamp
                    "endDate": endDateValue.timeIntervalSince1970,
                    "description": eventdesc,
                    "EventStatus": selectedStatus,
                    "EventImg": self.Eventurl // This will now be set correctly
                ]
                
           
                
                FirebaseDB.saveEventData(eventData: eventData) { success, errorMessage in
                    if success {
                        print("Event created successfully!")
                        // Optionally, you can navigate away from this view or clear the form
                    } else {
                        print("Error saving event: \(errorMessage ?? "Unknown error")")
                    }
                }
            }
        }
        
    }
}
    
