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
}


extension MainRouter : TargetType {
    var baseURL: URL {
        return URL(string:APIKey.baseURLWithVersion())!
    }
        
    var method: HTTPMethod {
        switch self {
        case .write :
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .write:
            return "/posts"
        }
    }
    
    var header: [String:String] {
        switch self {
        case .write :
            guard let token = UserDefaultManager.shared.accessToken else { return [:] }
            return [
                HTTPHeader.authorization.rawValue : token,
                HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
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
        }
    }
        
}
