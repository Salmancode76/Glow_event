//
import UIKit
import Cloudinary

class ImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageUpload: UIImageView!
    
    let cloudinary = CloudinarySetup.cloudinarySetup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func uploadImage(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.9) else {
            print("Error converting image to data")
            return
        }
        
        let uniqueID = UUID().uuidString //Generate a unique ID for the image
        let publicID = "event/images/\(uniqueID)"  // Cloudinary public ID

        
        let uploadParams = CLDUploadRequestParams()
        uploadParams.setPublicId(publicID) //Set the public ID
        
        cloudinary.createUploader().upload(data: data, uploadPreset: CloudinarySetup.uploadPreset, params: uploadParams, completionHandler: { response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error uploading image \(error.localizedDescription)")
                    return
                }
                
                if let secureUrl = response?.secureUrl {
                    print("Image uploaded successfully: \(secureUrl)") //Get the image URL
                    print("Public ID: \(response?.publicId ?? "N/A")") //Log the public ID
                    self.imageUpload.cldSetImage(secureUrl, cloudinary: self.cloudinary)
                }
            }
        })
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           guard let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage else {
               print("Error: No image selected")
               dismiss(animated: true, completion: nil)
               return
           }
           
           //Update the UIImageView
           imageUpload.image = selectedImage
           
           //Upload the selected image
           uploadImage(image: selectedImage)
           
           dismiss(animated: true, completion: nil)
       }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }

    @IBAction func gestureTap(_ sender: Any) {
        //Present the image picker when the gesture recognizer is triggered
        presentImagePicker()
    }
    
    func presentImagePicker() {
        let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
        
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
        
            present(imagePicker, animated: true, completion: nil)
    }
    
}

