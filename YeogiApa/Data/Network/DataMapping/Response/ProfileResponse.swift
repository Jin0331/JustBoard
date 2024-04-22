//
//  ProfileResponse.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/12/24.
//

import Foundation

struct ProfileResponse : Decodable {
    let user_id : String
    let email : String
    let nick : String
    let profileImage : String
    
    enum CodingKeys: String, CodingKey {
        case user_id
        case email
        case nick
        case profileImage
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.user_id = try container.decode(String.self, forKey: .user_id)
        self.email = try container.decode(String.self, forKey: .email)
        self.nick = try container.decode(String.self, forKey: .nick)
        self.profileImage = (try? container.decodeIfPresent(String.self, forKey: .profileImage)) ?? ""
    }
}
