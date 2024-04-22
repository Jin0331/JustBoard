//
//  MainRouter.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/19/24.
//

import Foundation
import Alamofire

enum MainRouter {
    case write(query : WriteRequest)
    case files(query : FilesRequest)
}


extension MainRouter : TargetType {
    var baseURL: URL {
        return URL(string:APIKey.baseURLWithVersion())!
    }
        
    var method: HTTPMethod {
        switch self {
        case .write, .files :
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .write:
            return "/posts"
        case .files:
            return "/posts/files"
        }
    }
    
    var header: [String:String] {
        guard let token = UserDefaultManager.shared.accessToken else { return [:] }
        
        switch self {
        case .write :
            return [
                HTTPHeader.authorization.rawValue : token,
                HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue : APIKey.secretKey.rawValue
            ]
        case .files :
            return [
                HTTPHeader.authorization.rawValue : token,
                HTTPHeader.contentType.rawValue : HTTPHeader.multipart.rawValue,
                HTTPHeader.sesacKey.rawValue : APIKey.secretKey.rawValue
            ]
        }
    }
    
    var parameter: Parameters? {
        return nil
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
        default:
            return nil
        }
    }
    
    var multipart: MultipartFormData {
          switch self {
          case .files(let filesRequest):
              let multiPart = MultipartFormData()

//              files.files.forEach { file in
//                  multiPart.append(file, withName: "files", fileName: "ImageTest.png", mimeType: "image/png")
//              }
              
              print(filesRequest.files[0], "✅ fielsRequest files [0]")
              
              multiPart.append(filesRequest.files[0], withName: "files", fileName: "ImageTest1.png", mimeType: "image/png")
              
              
              return multiPart
              
          default: return MultipartFormData()
          }
     }
        
}
