//
//  CreateChatResponse.swift
//  JustBoard
//
//  Created by JinwooLee on 5/18/24.
//

import Foundation

struct ChatResponse: Decodable, Identifiable, Hashable {
    var id = UUID()
    let roomID, createdAt, updatedAt: String
    let participants: [Sender]
    let lastChat: LastChat?

    enum CodingKeys: String, CodingKey {
        case roomID = "room_id"
        case createdAt, updatedAt, participants, lastChat
    }
    
    static func == (lhs: ChatResponse, rhs: ChatResponse) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - LastChat
struct LastChat: Decodable, Hashable {
    var id = UUID()
    let chatID, roomID, content, createdAt: String
    let sender: Sender
    let files: [String]

    enum CodingKeys: String, CodingKey {
        case chatID = "chat_id"
        case roomID = "room_id"
        case content, createdAt, sender, files
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.chatID = try container.decode(String.self, forKey: .chatID)
        self.roomID = try container.decode(String.self, forKey: .roomID)
        self.content = try container.decode(String.self, forKey: .content)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.sender = try container.decode(Sender.self, forKey: .sender)
        self.files = (try? container.decode([String].self, forKey: .files)) ?? []
    }
    
    static func == (lhs: LastChat, rhs: LastChat) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Sender
struct Sender: Decodable {
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
}
