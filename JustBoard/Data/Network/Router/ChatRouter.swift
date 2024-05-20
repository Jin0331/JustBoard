//
//  ChatRouter.swift
//  JustBoard
//
//  Created by JinwooLee on 5/16/24.
//

import Foundation
import Alamofire

enum ChatRouter {
    case create(query : ChatRequest)
    case myList
    case messageList(query : ChatMessageRequest, roomId : String)
    case send(query : ChatSendRequest, roomId : String)
    case sendFiles(query : ChatSendFilesRequest, roomId : String)
}

extension ChatRouter : TargetType {
    var baseURL: URL {
        return URL(string:APIKey.baseURLWithVersion())!
    }
    
    var method: HTTPMethod {
        switch self {
        case .create, .send, .sendFiles :
            return .post
        case .myList, .messageList:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .create, .myList:
            return "/chats"
        case .messageList(query: _, roomId: let roomId), .send(query: _, roomId: let roomId):
            return "/chats/" + roomId
        case .sendFiles(query: _, roomId: let roomId):
            return "/chats/" + roomId + "/files"
        }
    }
    
    var header: [String : String] {
        guard let token = UserDefaultManager.shared.accessToken else { return [:] }
        
        switch self {
        case .create, .send:
            return [
                HTTPHeader.authorization.rawValue : token,
                HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue : APIKey.secretKey.rawValue
            ]
        case .myList, .messageList:
            return [
                HTTPHeader.authorization.rawValue : token,
                HTTPHeader.sesacKey.rawValue : APIKey.secretKey.rawValue
            ]
        case .sendFiles:
            return [
                HTTPHeader.authorization.rawValue : token,
                HTTPHeader.contentType.rawValue : HTTPHeader.multipart.rawValue,
                HTTPHeader.sesacKey.rawValue : APIKey.secretKey.rawValue
            ]
        }
    }
    
    var parameter: Parameters? {
        switch self {
        case .messageList(query: let query, roomId: _):
            return [QueryString.chatCursor.rawValue : query.cursor_date]
        default :
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .create(query: let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            
            return try? encoder.encode(query)
        case .send(query: let query, roomId: _):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            
            return try? encoder.encode(query)
            
        default:
            return nil
        }
    }
    
    var multipart: MultipartFormData {
        switch self {
        case .sendFiles(query: let filesRequest, roomId: let roomId):
            let multiPart = MultipartFormData()
            
            // 빈 배열일 경우
            if filesRequest.files.isEmpty {
                print("빈배열")
                return multiPart
            } else {
                filesRequest.files.forEach { file in
                    multiPart.append(file, withName: "files", fileName: roomId + ".jpeg", mimeType: "image/jpeg")
                    print("✅ fielsRequest \(file)")
                }
                return multiPart
            }
            
        default: return MultipartFormData()
            
        }
    }
}
