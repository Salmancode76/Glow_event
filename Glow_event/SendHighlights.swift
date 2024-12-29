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
    
    
    @IBAction func SendButtonTapped(_ sender: Any) {
        
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
