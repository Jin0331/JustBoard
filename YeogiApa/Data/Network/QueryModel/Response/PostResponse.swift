//
//  PostResponse.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/19/24.
//

import Foundation

struct InquiryResponse : Decodable, Hashable {
    let data : [PostResponse]
    let next_cursor : String
    
    static func == (lhs: InquiryResponse, rhs: InquiryResponse) -> Bool {
        return lhs.data == rhs.data && lhs.next_cursor == rhs.next_cursor
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(data)
    }
}

struct PostResponse: Decodable, Hashable {
    let postID, productID, title: String
    let content, content1, content2, content3, createdAt : String
    let creator: Creator
    let files : [String]
    let comments: [Comment]
    let hashTags: [String]

    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case productID = "product_id"
        case title, content1, content2, content3, content, createdAt, creator, files, comments, hashTags
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.postID = try container.decode(String.self, forKey: .postID)
        self.productID = try container.decode(String.self, forKey: .productID)
        self.title = try container.decode(String.self, forKey: .title)
        self.content = (try? container.decode(String.self, forKey: .content)) ?? ""
        self.content1 = (try? container.decode(String.self, forKey: .content1)) ?? ""
        self.content2 = (try? container.decode(String.self, forKey: .content2)) ?? ""
        self.content3 = (try? container.decode(String.self, forKey: .content3)) ?? ""
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.creator = try container.decode(Creator.self, forKey: .creator)
        self.files = try container.decode([String].self, forKey: .files)
        self.comments = try container.decode([Comment].self, forKey: .comments)
        self.hashTags = (try? container.decode([String].self, forKey: .hashTags)) ?? []
    }
    
    static func == (lhs: PostResponse, rhs: PostResponse) -> Bool {
        return lhs.postID == rhs.postID &&
               lhs.productID == rhs.productID &&
               lhs.title == rhs.title &&
               lhs.content == rhs.content &&
               lhs.content1 == rhs.content1 &&
               lhs.content2 == rhs.content2 &&
               lhs.content3 == rhs.content3 &&
               lhs.createdAt == rhs.createdAt &&
               lhs.creator == rhs.creator &&
               lhs.files == rhs.files &&
               lhs.comments == rhs.comments &&
               lhs.hashTags == rhs.hashTags
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(postID)
    }
    
}

struct Comment: Decodable, Hashable {
    let commentID, content, createdAt: String
    let creator: Creator

    enum CodingKeys: String, CodingKey {
        case commentID = "comment_id"
        case content, createdAt, creator
    }
    
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.commentID == rhs.commentID &&
        lhs.content == rhs.content &&
        lhs.createdAt == rhs.createdAt &&
        lhs.creator == rhs.creator
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(commentID)
    }
}

struct Creator: Decodable, Hashable {
    let userID, nick, profileImage: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nick, profileImage
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userID = try container.decode(String.self, forKey: .userID)
        self.nick = try container.decode(String.self, forKey: .nick)
        self.profileImage = (try? container.decode(String.self, forKey: .profileImage)) ?? ""
    }
}


