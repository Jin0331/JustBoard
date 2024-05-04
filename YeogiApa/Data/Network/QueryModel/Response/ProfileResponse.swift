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
    let posts : [String]
    let followers: [Follow]
    let following: [Follow]
    
    enum CodingKeys: String, CodingKey {
        case user_id
        case email
        case nick
        case profileImage
        case posts
        case followers, following
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.user_id = try container.decode(String.self, forKey: .user_id)
        self.email = (try? container.decode(String.self, forKey: .email)) ?? ""
        self.nick = try container.decode(String.self, forKey: .nick)
        self.profileImage = (try? container.decode(String.self, forKey: .profileImage)) ?? DesignSystem.defaultimage.defaultProfile
        self.posts = (try? container.decodeIfPresent([String].self, forKey: .posts)) ?? []
        self.followers = (try? container.decodeIfPresent([Follow].self, forKey: .followers)) ?? []
        self.following = (try? container.decodeIfPresent([Follow].self, forKey: .following)) ?? []
    }
    
    var profileImageToUrl : URL {
        return URL(string: APIKey.baseURLWithVersion() + "/" + profileImage)!
    }
}

struct Follow: Decodable {
    let userID, nick: String
    let profileImage: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nick, profileImage
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decode(String.self, forKey: .userID)
        self.nick = try container.decode(String.self, forKey: .nick)
        self.profileImage = (try? container.decode(String.self, forKey: .profileImage)) ?? DesignSystem.defaultimage.defaultProfile
    }
    
    var profileImageToUrl : URL {
        return URL(string: APIKey.baseURLWithVersion() + "/" + profileImage)!
    }
}
