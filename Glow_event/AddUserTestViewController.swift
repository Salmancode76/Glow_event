//
//  AddUserTestViewController.swift
//  Glow_event
//
//  Created by Zainab on 24/12/2024.
//

import UIKit

class AddUserTestViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var genderTextField: UITextField!
    
    var genders = ["Male", "Female"] // Array of genders
        
        let picker = UIPickerView() // Create picker instance
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Set up picker delegate and data source
            picker.delegate = self
            picker.dataSource = self
            
            // Bind the picker to the gender text field
            genderTextField.inputView = picker
        }
        
        // Number of components (columns) in picker
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1 // Only one column for genders
        }
        
        // Number of rows in picker (data source count)
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return genders.count // Number of genders
        }
        
        // Title for each row in the picker
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return genders[row] // Return the corresponding gender for the row
        }
        
        // Handle row selection in the picker
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            genderTextField.text = genders[row] // Set selected gender in text field
            self.view.endEditing(true) // Close the picker
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
