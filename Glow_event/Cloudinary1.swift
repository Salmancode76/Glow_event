//
//  Cloudinary.swift
//  Glow_event
//
//  Created by PRINTANICA on 27/12/2024.
//

import Foundation
import Cloudinary

class CloudinaryManager {
    static let shared = CloudinaryManager()

    let cloudinary: CLDCloudinary

    private init() {
        let config = CLDConfiguration(cloudName: "doctomog7", secure: true)
        cloudinary = CLDCloudinary(configuration: config)
    }
}
