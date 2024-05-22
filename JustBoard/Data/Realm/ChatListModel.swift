//
//  ChatListModel.swift
//  JustBoard
//
//  Created by JinwooLee on 5/21/24.
//

import Foundation
import RealmSwift

final class RealmChatResponse: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var roomID: String
    @Persisted var createdAt: String
    @Persisted var updatedAt: String
    @Persisted var participants : List<RealmSender>
    @Persisted var lastChat: RealmLastChat?
}

final class RealmLastChat: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id : ObjectId
    @Persisted var chatID: String
    @Persisted var roomID: String
    @Persisted var content: String
    @Persisted var createdAt: String
    @Persisted var sender: RealmSender?
    @Persisted var files : List<String>
}

class RealmSender: Object, ObjectKeyIdentifiable{
    @Persisted var userID: String
    @Persisted var nick: String
    @Persisted var profileImage: String
}

extension RealmChatResponse {
    convenience init(from chatResponse: ChatResponse) {
        self.init()
        roomID = chatResponse.roomID
        createdAt = chatResponse.createdAt
        updatedAt = chatResponse.updatedAt
        participants.append(objectsIn: chatResponse.participants.map(RealmSender.init))
        lastChat = chatResponse.lastChat.map(RealmLastChat.init)
    }
}

extension RealmLastChat {
    convenience init(from lastChat: LastChat) {
        self.init()
        chatID = lastChat.chatID
        roomID = lastChat.roomID
        content = lastChat.content
        createdAt = lastChat.createdAt
        sender = RealmSender(from: lastChat.sender)
        files.append(objectsIn: lastChat.files)
    }
}

extension RealmSender {
    convenience init(from sender: Sender) {
        self.init()
        userID = sender.userID
        nick = sender.nick
        profileImage = sender.profileImage
    }
}
