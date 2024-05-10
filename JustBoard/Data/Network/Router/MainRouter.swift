//
//  MainRouter.swift
//  JustBoard
//
//  Created by JinwooLee on 4/19/24.
//

import Foundation
import Alamofire

enum MainRouter {
    case write(query : PostRequest)
    case files(query : FilesRequest, category : String)
    case inquiry(query : InquiryRequest)
    case specificInquiry(postId : String)
    case comment(query : CommentRequest, postId : String)
    case likes(query : LikesRequest, postId : String)
    case meProfile
    case otherProfile(userId : String)
    case meProfileEdit(query : ProfileEditRequest)
    case follow(userId : String)
    case followCancel(userId : String)
    case withdraw
}

extension MainRouter : TargetType {
    var baseURL: URL {
        return URL(string:APIKey.baseURLWithVersion())!
    }
    
    var method: HTTPMethod {
        switch self {
        case .write, .files, .comment, .likes, .follow:
            return .post
        case .inquiry, .specificInquiry, .meProfile, .otherProfile, .withdraw:
            return .get
        case .followCancel:
            return .delete
        case .meProfileEdit:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .write, .inquiry:
            return "/posts"
        case .files:
            return "/posts/files"
        case .specificInquiry(postId: let postId):
            return "/posts/" + postId
        case .comment(query: _ , postId: let postId):
            return "/posts/" + postId + "/comments"
        case .likes(query: _ , postId: let postId):
            return "/posts/" + postId + "/like"
        case .meProfile, .meProfileEdit:
            return "/users/me/profile"
        case .otherProfile(userId: let userId):
            return "/users/" + userId + "/profile"
        case .follow(userId: let userId), .followCancel(userId: let userId):
            return "/follow/" + userId
        case .withdraw:
            return "/users/withdraw"
        }
    }
    
    var header: [String:String] {
        guard let token = UserDefaultManager.shared.accessToken else { return [:] }
        
        switch self {
        case .write, .comment, .likes:
            return [
                HTTPHeader.authorization.rawValue : token,
                HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue : APIKey.secretKey.rawValue
            ]
        case .files, .meProfileEdit :
            return [
                HTTPHeader.authorization.rawValue : token,
                HTTPHeader.contentType.rawValue : HTTPHeader.multipart.rawValue,
                HTTPHeader.sesacKey.rawValue : APIKey.secretKey.rawValue
            ]
        case .inquiry, .specificInquiry, .meProfile, .otherProfile, .follow, .followCancel, .withdraw:
            return [
                HTTPHeader.authorization.rawValue : token,
                HTTPHeader.sesacKey.rawValue : APIKey.secretKey.rawValue
            ]
        }
    }
    
    var parameter: Parameters? {
        switch self {
        case .inquiry(query: let query):
            return [QueryString.next.rawValue : query.next,
                    QueryString.limit.rawValue : query.limit,
                    QueryString.product_id.rawValue : query.product_id]
        default :
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .write(query: let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            
            return try? encoder.encode(query)
            
        case .comment(query: let query, postId: _):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            
            return try? encoder.encode(query)
            
        case .likes(query: let query, postId: _):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            
            return try? encoder.encode(query)
            
        default:
            return nil
        }
    }
    
    var multipart: MultipartFormData {
        switch self {
        case .files(let filesRequest, let category):
            let multiPart = MultipartFormData()
            
            // 빈 배열일 경우
            if filesRequest.files.isEmpty {
                print("빈배열")
                return multiPart
            } else {
                filesRequest.files.forEach { file in
                    multiPart.append(file, withName: "files", fileName: category + ".jpeg", mimeType: "image/jpeg")
                    print("✅ fielsRequest \(file)")
                }
                return multiPart
            }
        
        case .meProfileEdit(let fileRequest):
            let multiPart = MultipartFormData()
            
            multiPart.append(fileRequest.nick.data(using: .utf8)!, withName: "nick")
            multiPart.append(fileRequest.profile, withName: "profile", fileName: fileRequest.nick + "_profile.jpeg", mimeType: "image/jpeg")
            
            return multiPart
            
        default: return MultipartFormData()
            
        }
    }
}

