//
//  WriteResponse.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/19/24.
//

import Foundation

// MARK: - Welcome
struct WriteResponse: Decodable {
    let postID, productID, title: String
    let content : String
    let creator: Creator
    let hashTags: [String]

    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case productID = "product_id"
        case title, content, creator, hashTags
    }
    
}

// MARK: - Creator
struct Creator: Decodable {
    let userID, nick, profileImage: String

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decode(String.self, forKey: .userID)
        self.nick = try container.decode(String.self, forKey: .nick)
        self.profileImage = (try? container.decode(String.self, forKey: .profileImage)) ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nick, profileImage
    }
}
