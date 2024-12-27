//
//  User.swift
//  Glow_event
//
//  Created by Hadi Abdulla on 22/12/2024.
//

import Foundation

class User: Equatable, Comparable, CustomStringConvertible {
    
    var username: String
    var password: String
    var uid: UUID
    var userType: UserType
    
    //Custom String Representation using the CustomeStringConvertible protocol
    var description: String {
        return """
                - User Information -
                ID: \(uid)
                Username: \(username)
            """
    }
    
    init(username: String, password: String, userType: UserType) {
        self.username = username
        self.password = password
        self.uid = UUID()
        self.userType = userType
    }
    
    /*Equatable Protocol Implementation
      Comparing two User instances for equality based on their usernames
    */
    static func == (lhs: User, rhs: User) -> Bool {
        return (lhs.username == rhs.username)
    }
    
    /*Comparable Protocol Implementation
      Comparing two User instances for equality based on their usernames, enables sorting
    */
    static func < (lhs: User, rhs: User) -> Bool {
        return (lhs.username < rhs.username)
    }
    
    
    /*Function to Encode User Details using the Codable protocol
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(username, forKey: .username)
        try container.encode(password, forKey: .password)
        try container.encode(uid, forKey: .uid)
        try container.encode(userType, forKey: .userType)
    }
    
    /*Decoding initializer
      Allows the creation of user instance from Decoder [Decoding properties from serialized format]
     */
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try container.decode(String.self, forKey: .username)
        self.password = try container.decode(String.self, forKey: .password)
        self.uid = try container.decode(UUID.self, forKey: .uid)
        self.userType = try container.decode(UserType.self, forKey: .userType)
    }*/
    
    
}
