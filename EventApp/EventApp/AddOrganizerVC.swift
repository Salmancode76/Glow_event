
import UIKit

protocol AddOrganizerDelegate: AnyObject {
    func didSaveOrganizer(_ organizer: Organizer, at index: Int?)
}

class AddOrganizerVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var logoTF: UITextField!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var websiteURLTF: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var detailLbl: UILabel!
    
    lazy var imagePicker = UIImagePickerController()
    
    var organizer: Organizer?
    weak var delegate: AddOrganizerDelegate?
    var organizerIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoTF.addTarget(self, action: #selector(handlepickPicture), for: .touchDown)
        
        if let organizer = organizer {
            // Populate fields for editing
            logoTF.text = organizer.logo
            userNameTF.text = organizer.userName
            emailTF.text = organizer.email
            passwordTF.text = organizer.password
            phoneTF.text = organizer.phone
            websiteURLTF.text = organizer.websiteURL
            saveButton.setTitle("Save", for: .normal)
            title = "Edit Organizer"
            detailLbl.text = "Please fill the form to update Organizer details"
        } else {
            title = "Add Organizer"
            detailLbl.text = "Please fill the form to add an Organizer"
            saveButton.setTitle("Add", for: .normal)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.originalImage] as? UIImage {
            logoTF.text = "Image selected"
            // Handle the selected image here
        }
        picker.dismiss(animated: true)
    }
    
    @objc fileprivate func handlepickPicture() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.view.tintColor = .white
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.allowsEditing = true
        imagePicker.navigationBar.barTintColor = .black
        
        present(imagePicker, animated: true)
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let logo = logoTF.text,
              let userName = userNameTF.text,
              let email = emailTF.text,
              let password = passwordTF.text,
              let phone = phoneTF.text,
              let websiteURL = websiteURLTF.text else { return }
        
        let newOrganizer = Organizer(logo: logo, userName: userName, email: email, password: password, phone: phone, websiteURL: websiteURL)
        delegate?.didSaveOrganizer(newOrganizer, at: organizerIndex)
        navigationController?.popViewController(animated: true)
    }
    
}
