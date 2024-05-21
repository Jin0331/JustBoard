//
//  ChatModel.swift
//  JustBoard
//
//  Created by JinwooLee on 5/20/24.
//

import Foundation
import RealmSwift

final class Chat : Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id : ObjectId
    @Persisted var roomID : String
    @Persisted var chatID : String
    @Persisted var userID : String
    @Persisted var nick : String
    @Persisted var profile : String
    @Persisted var content : String
    @Persisted var createdAt : Date
    
    convenience init(roomID : String, chatID : String, userID : String, nick : String, profile : String, content : String, createAt : Date) {
        self.init()
        self.roomID = roomID
        self.chatID = chatID
        self.userID = userID
        self.nick = nick
        self.profile = profile
        self.content = content
        self.createdAt = createAt
    }
    
    var profileImageToUrl : URL {
        return URL(string: APIKey.baseURLWithVersion() + "/" + profile)!
    }
}
