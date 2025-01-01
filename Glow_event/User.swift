//
//  User.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 22/12/2024.
//

import Foundation

class User: CustomStringConvertible {
    
    var username: String
    var password: String
    var uid: String
    var userType: UserType
    
    
    //Custom String Representation using the CustomeStringConvertible protocol
    var description: String {
        return """
                - User Information -
                ID: \(uid)
                Username: \(username)
                UserType: \(userType)
            """
    }
    
    init(uid: String, username: String, password: String, userType: UserType) {
        self.uid = uid
        self.username = username
        self.password = password
        self.uid = UUID().uuidString
        self.userType = userType
    }
    
}
