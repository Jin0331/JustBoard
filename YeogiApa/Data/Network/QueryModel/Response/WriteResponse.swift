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
    let content, content1, content2, content3 : String
    let creator: Creator
    let files : [String]
    let hashTags: [String]

    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case productID = "product_id"
        case title, content1, content2, content3, content, creator, files, hashTags
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.postID = try container.decode(String.self, forKey: .postID)
        self.productID = try container.decode(String.self, forKey: .productID)
        self.title = try container.decode(String.self, forKey: .title)
        self.content = (try? container.decode(String.self, forKey: .content)) ?? ""
        self.content1 = try container.decode(String.self, forKey: .content1)
        self.content2 = try container.decode(String.self, forKey: .content2)
        self.content3 = try container.decode(String.self, forKey: .content3)
        self.creator = try container.decode(Creator.self, forKey: .creator)
        self.files = try container.decode([String].self, forKey: .files)
        self.hashTags = try container.decode([String].self, forKey: .hashTags)
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
