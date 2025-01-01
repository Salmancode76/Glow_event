//
//  SendHighlights.swift
//  Glow_event
//
//  Created by PRINTANICA on 28/12/2024.
//

import UIKit
import Firebase
import FirebaseDatabase
import Cloudinary

class SendHighlights: UIViewController, UIImagePickerControllerDelegate, UIPickerViewDelegate, UINavigationControllerDelegate, UIPickerViewDataSource {
    
    
 
    

    
    
    
    
    let cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: "doctomog7", apiKey: "124238775731624", apiSecret: "tYPeSodcr74HxjzPSUxme_ZQEhY"))
    
    
    @IBOutlet weak var OrganizerName: UITextField!
    
    @IBOutlet weak var ImageSelected: UIImageView!
    var organizerNames: [String] = []
        var pickerView: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView = UIPickerView()
               pickerView.delegate = self
               pickerView.dataSource = self
       
               OrganizerName.inputView = pickerView
        OrganizerName.inputAccessoryView = createPickerToolbar() 
        
        
        
        fetchOrganizers { [weak self] names in
                   self?.organizerNames = names
                   self?.pickerView.reloadAllComponents()
               }
            
            
            // Do any additional setup after loading the view.
        }
    
    func fetchOrganizers(completion: @escaping ([String]) -> Void) {
           let ref = Database.database().reference().child("organizers") // Reference to your "organizers" node
           ref.observeSingleEvent(of: .value) { (snapshot) in
               var organizerNames: [String] = []
               for child in snapshot.children {
                   if let childSnapshot = child as? DataSnapshot,
                      let organizerData = childSnapshot.value as? [String: Any],
                      let name = organizerData["name"] as? String {
                       organizerNames.append(name)
                   }
               }
               completion(organizerNames)
           } withCancel: { (error) in
               print("Error fetching organizers: \(error.localizedDescription)")
               completion([]) // Return an empty array in case of error
           }
       }
       
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1 // Only one component for organizer names
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return organizerNames.count
       }
       
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return organizerNames[row]
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           OrganizerName.text = organizerNames[row] 
           OrganizerName.resignFirstResponder() // Set the selected organizer name to the text field
       }
       
       // Function to create a toolbar with a "Done" button for the picker view
       func createPickerToolbar() -> UIToolbar {
           let toolbar = UIToolbar()
           toolbar.sizeToFit()
           
           let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
           let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           
           toolbar.setItems([flexibleSpace, doneButton], animated: false)
           return toolbar
       }
       
       @objc func donePressed() {
           OrganizerName.resignFirstResponder() // Dismiss the picker
       }
       
        
    
   
    
    
    @IBAction func UploadPic(_ sender: Any) {
        let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            ImageSelected.image = image // Display the selected image
        }
        dismiss(animated: true, completion: nil)
    }
    
    
   
    @IBAction func send(_ sender: UIButton) {
        
        guard let organizerName = OrganizerName.text, !organizerName.isEmpty else {
              showAlert(title: "Error", message: "Please select an organizer.")
              return
          }

          guard let image = ImageSelected.image else {
              showAlert(title: "Error", message: "Please select an image.")
              return
          }

          guard let imageData = image.jpegData(compressionQuality: 0.8) else {
              showAlert(title: "Error", message: "Failed to process the image.")
              return
          }

          // Start uploading the image to Cloudinary
          let uploader = cloudinary.createUploader()
        uploader.upload(data: imageData, uploadPreset: "glow_event", completionHandler:  { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Cloudinary upload error: \(error.localizedDescription)")
                self.showAlert(title: "Upload Failed", message: "Could not upload the image to Cloudinary.")
                return
            }
            
            if let result = result, let imageUrl = result.url {
                print("Image uploaded to Cloudinary: \(imageUrl)")
                self.storeImageDetailsInFirebase(imageUrl: imageUrl, organizerName: organizerName)
            } else {
                self.showAlert(title: "Error", message: "Unexpected error during image upload.")
            }
        })
      }

      private func storeImageDetailsInFirebase(imageUrl: String, organizerName: String) {
          let ref = Database.database().reference().child("organizers")

          // Find the organizer node by name
          ref.queryOrdered(byChild: "name").queryEqual(toValue: organizerName).observeSingleEvent(of: .value) { snapshot in
              guard snapshot.exists(), let organizerSnapshot = snapshot.children.allObjects.first as? DataSnapshot else {
                  self.showAlert(title: "Error", message: "Organizer not found in the database.")
                  return
              }

              let organizerKey = organizerSnapshot.key // Organizer node key
              let highlightsRef = ref.child(organizerKey).child("highlights")

              // Create a unique key for the highlight entry
              let highlightKey = highlightsRef.childByAutoId().key

              let highlightDetails: [String: Any] = [
                  "imageUrl": imageUrl,
                  "timestamp": ServerValue.timestamp()
              ]

              // Save the highlight data under the organizer's node
              highlightsRef.child(highlightKey!).setValue(highlightDetails) { error, _ in
                  if let error = error {
                      print("Firebase write error: \(error.localizedDescription)")
                      self.showAlert(title: "Error", message: "Could not save data to Firebase.")
                  } else {
                      self.showAlert(title: "Success", message: "Highlight successfully sent.")
                  }
              }
          } withCancel: { error in
              print("Firebase query error: \(error.localizedDescription)")
              self.showAlert(title: "Error", message: "Could not fetch organizer details.")
          }
      }

      private func showAlert(title: String, message: String) {
          let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default))
          present(alert, animated: true)
    }
    /*
     @IBAction func SendingEo(_ sender: Any) {
     }
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
