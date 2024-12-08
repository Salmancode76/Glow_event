//
//  ViewController.swift
//  Glow_event
//
//  Created by BP-36-201-09 on 25/11/2024.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import Cloudinary




class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
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
    

    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBAction func venu_options(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.



 
        print(cloudinary)


        imageview.image = UIImage(systemName: "photo.fill")  // A filled photo symbol

    
        startpicker.tintColor = .white
        startpicker.backgroundColor = .black
        
        


        
        startpicker.contentHorizontalAlignment = .left
        endpicker.contentHorizontalAlignment = .left
        
    
        
        
        // Set the tint color to white
       
        
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
/*
    // This function uploads the image to Firebase Storage
    func uploadImageToFirebase(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            print("Error: Failed to convert image to data")
            completion(nil)
            return
        }

        // Reference to Firebase Storage
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("event_images/\(UUID().uuidString).jpg") // Unique name for the image

        // Upload the image
        imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Get the download URL once the image is uploaded
            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                // If successful, return the URL
                if let downloadURL = url {
                    completion(downloadURL.absoluteString)
                }
            }
        }
    }
 */

    
    
    
    
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
    // This function saves event data to Firebase Realtime Database
    func saveEventDataToFirebase(_ eventData: [String: Any]) {
        let ref = Database.database(url: "https://glowevent-9be31-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        
        ref.child("events").childByAutoId().setValue(eventData) { error, reference in
            if let error = error {
                print("Error saving event: \(error.localizedDescription)")
            } else {
                print("Event saved successfully!")
            }
        }
}
    func uploadImage(image: UIImage) {
       // Try to convert the image to JPEG data
       guard let imageData = image.jpegData(compressionQuality: 0.9) else {
           print("Failed to convert image to data.")
           return
       }
       
       let uniqueID = UUID().uuidString // Generate a unique ID for the image
       let publicID = "event/images/\(uniqueID)" // Cloudinary public ID
        Eventurl = publicID
       
       let uploadParams = CLDUploadRequestParams()
       uploadParams.setPublicId(publicID) // Set the public ID
       
       cloudinary.createUploader().upload(data: imageData, uploadPreset: CloudinarySetup.uploadPreset, params: uploadParams) { response, error in
           if let error = error {
               print("Error uploading image: \(error.localizedDescription)")
           } else if let secureUrl = response?.secureUrl {
               print("Image uploaded successfully! URL: \(secureUrl)")

               guard let secureUrl = response?.secureUrl else {
                   print("Failed to get secure URL from Cloudinary.")
                   return
               }
               
               // Now that secureUrl is unwrapped, assign it to self.Eventurl
               self.Eventurl =  "https://res.cloudinary.com/doctomog7/image/upload/v1733502346/event/images/" + secureUrl
               
               
               print(self.Eventurl)

           }
       }
   }
    
  
    
    
    /*
    private func uploadImage(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.9) else {
            print("Error converting image to data")
            return
        }
        
        let uniqueID = UUID().uuidString //Generate a unique ID for the image
        let publicID = "images/user/\(uniqueID)" //Specify the folder reference
        
        let uploadParams = CLDUploadRequestParams()
        uploadParams.setPublicId(publicID) //Set the public ID
        
        cloudinary.createUploader().upload(data: data, uploadPreset: CloudinarySetup.uploadPreset, params: uploadParams, completionHandler: { response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    return
                }
                
                if let secureUrl = response?.secureUrl {
                    print("Image uploaded successfully: \(secureUrl)") //Get the image URL
                    print("Public ID: \(response?.publicId ?? "N/A")") //Log the public ID
                    self.selectedEventImage.cldSetImage(secureUrl, cloudinary: self.cloudinary)
                }
            }
        })
    }
     */
   
    
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
        
        
        uploadImage(image: eventImage)


        
        // Initialize the Event struct with the values
        let event = Event(EventName: eventName,
                          venu_options: selectedVenue,
                          price: enteredPrice,
                          startDate: startDateValue,
                          endDate: endDateValue,
                          descrip: eventdesc,
                          EventStatus: selectedStatus,
                          EventPhotoURL: Eventurl)
        
        
        
        
        
        // Print the event to verify
        print("Event created: \(event)")
       
        // Create the event dictionary
        
         let eventData: [String: Any] = [
         "EventName": eventName,
         "venue_options": selectedVenue,
         "price": enteredPrice,
         "startDate": startDateValue.timeIntervalSince1970,  // Firebase stores time as timestamp
         "endDate": endDateValue.timeIntervalSince1970,
         "description": eventdesc
         ,
         "EventStatus": selectedStatus,
         "EventImg": Eventurl
         ]
        
         
        
        // Reference to the Firebase Realtime Database
        let ref = Database.database(url: "https://glowevent-9be31-default-rtdb.asia-southeast1.firebasedatabase.app").reference()
        
        // Push the event data into the "events" node
        ref.child("events").childByAutoId().setValue(eventData) { (error, reference) in
            if let error = error {
                print("Error saving event: \(error.localizedDescription)")
            } else {
                print("Event saved successfully!")
            }
        }
    }
    
    
    
    
    
    
  

    
  
    
    
    
}


