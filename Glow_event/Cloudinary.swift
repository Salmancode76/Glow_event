import Foundation
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
}

