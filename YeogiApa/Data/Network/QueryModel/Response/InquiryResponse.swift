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
    enum CodingKeys: CodingKey {
        case data
        case next_cursor
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode([PostResponse].self, forKey: .data)
        
        self.next_cursor = try container.decode(String.self, forKey: .next_cursor)
    }
    
    var rankData : [PostRank] {
        var returndata : [PostRank] = []
            
        var productCountDict: [String: Int] = [:]
        for post in data {
            if let count = productCountDict[post.productID] {
                productCountDict[post.productID] = count + 1
            } else {
                productCountDict[post.productID] = 1
            }
        }

        let sortedCounts = productCountDict.sorted { $0.value > $1.value }
        
        for (rank, post) in sortedCounts.enumerated() {
            print("Product ID: \(post.key), Rank: \(rank)")
            returndata.append(PostRank(productId: post.key, boardRank: rank, count: productCountDict[post.key]!))
        }
        
        return returndata
    }
    
    var userRankData : [UserRank] {
        var returndata : [UserRank] = []
            
        var productCountDict: [String: Int] = [:]
        for post in data {
            if let count = productCountDict[post.nickname] {
                productCountDict[post.nickname] = count + 1
            } else {
                productCountDict[post.nickname] = 1
            }
        }

        let sortedCounts = productCountDict.sorted { $0.value > $1.value }
        
        for (rank, post) in sortedCounts.enumerated() {
            print("Nickname: \(post.key), Rank: \(rank)")
            returndata.append(UserRank(nickName: post.key, boardRank: rank, count: productCountDict[post.key]!))
        }
        
        return returndata
    }
    
    var postRank : [(PostRank, UserRank)] {
        let ranks = zip(rankData, userRankData)
        return Array(ranks)
    }
    
}

struct PostResponse: Decodable, Hashable {
    let postID, productID, title: String
    let content, content1, content2, content3, createdAt : String
    let creator: Creator
    let files : [String]
    let comments: [Comment]
    let likes : [String]
    let hashTags: [String]

    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case productID = "product_id"
        case title, content1, content2, content3, content, createdAt, creator, files, comments, likes,hashTags
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.postID = try container.decode(String.self, forKey: .postID)
        self.productID = (try? container.decode(String.self, forKey: .productID)) ?? ""
        self.title = (try? container.decode(String.self, forKey: .title)) ?? ""
        self.content = (try? container.decode(String.self, forKey: .content)) ?? ""
        self.content1 = (try? container.decode(String.self, forKey: .content1)) ?? ""
        self.content2 = (try? container.decode(String.self, forKey: .content2)) ?? ""
        self.content3 = (try? container.decode(String.self, forKey: .content3)) ?? ""
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.creator = try container.decode(Creator.self, forKey: .creator)
        self.files = (try? container.decode([String].self, forKey: .files)) ?? []
        self.likes = (try? container.decode([String].self, forKey: .likes)) ?? []
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
               lhs.likes == rhs.likes &&
               lhs.hashTags == rhs.hashTags
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(postID)
    }
    
    var content3ToImageLocation : [Int] {
        
        if content3.isEmpty {
            return []
        } else {
            let convert = content3.split(separator: " ").compactMap{ Int($0) }
            
            return convert
        }
    }
    
    var filesToUrl : [URL] {
        return files.map { 
            URL(string: APIKey.baseURLWithVersion() + "/" + $0)!
        }
    }
    
    var createdAtToTime : String {
        return createdAt.formatDateString()
    }
    
    var createdAtToTimeDate : Date {
        return createdAt.toDate(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")!
    }
    
    var nickname : String {
        return creator.nick
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

struct PostRank : Hashable {
    let productId : String
    let boardRank : Int
    let count : Int
    
    static func == (lhs: PostRank, rhs: PostRank) -> Bool {
        return lhs.productId == rhs.productId &&
        lhs.boardRank == rhs.boardRank
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(productId)
    }
}

struct UserRank : Hashable {
    let nickName : String
    let boardRank : Int
    let count : Int
    
    static func == (lhs: UserRank, rhs: UserRank) -> Bool {
        return lhs.nickName == rhs.nickName &&
        lhs.boardRank == rhs.boardRank
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(nickName)
    }
}
