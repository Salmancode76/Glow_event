import UIKit
import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import Cloudinary

struct CloudinarySetup {
    
    static var cloudinary : CLDCloudinary!

    static let cloudName: String = "doctomog7" // Make this static

    static let uploadPreset: String = "glow_event" //Upload preset
    
    static func cloudinarySetup() -> CLDCloudinary {
        
        let config = CLDConfiguration(cloudName: CloudinarySetup.cloudName, secure: true)
        
        cloudinary = CLDCloudinary(configuration: config)
        
        return cloudinary
    }
    
    
    // Updated uploadImage to use a completion handler
        static func uploadeEventImage(image: UIImage, completion: @escaping (String?) -> Void) {
            // Try to convert the image to JPEG data
            guard let imageData = image.jpegData(compressionQuality: 0.9) else {
                print("Failed to convert image to data.")
                completion(nil) // Return nil if conversion fails
                return
            }
            
            let uniqueID = UUID().uuidString // Generate a unique ID for the image
            let publicID = "event/images/\(uniqueID)" // Cloudinary public ID
            
            let uploadParams = CLDUploadRequestParams()
            uploadParams.setPublicId(publicID) // Set the public ID
            
            // Start uploading the image
            CloudinarySetup.cloudinary.createUploader().upload(data: imageData, uploadPreset: CloudinarySetup.uploadPreset, params: uploadParams, completionHandler:  { response, error in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    completion(nil) // Return nil in case of error
                } else if let secureUrl = response?.secureUrl {
                    print("Image uploaded successfully! URL: \(secureUrl)")
                    completion(secureUrl) // Return the secure URL in the completion handler
                } else {
                    print("Failed to get secure URL from Cloudinary.")
                    completion(nil) // Return nil if URL is not found
                }
            })
            
        }
    
    
    // Download an image from Cloudinary URL and return as UIImage
    static func DownloadEventyImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        // Ensure the URL is valid
        guard let imageURL = URL(string: url) else {
            print("Invalid URL")
            completion(nil)
            return
        }

        // Start downloading the image asynchronously
        let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    // Convert data to UIImage and return via the completion handler
                    if let image = UIImage(data: data) {
                        completion(image)
                    } else {
                        print("Failed to convert data to UIImage")
                        completion(nil)
                    }
                }
            } else {
                print("Error downloading image: \(String(describing: error))")
                completion(nil)
            }
        }
        task.resume() // Start the download task
    }
    
    
    
    
}

