//
//  Router.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/9/24.
//

import Foundation
import Alamofire

enum Router {
    case login(query : LoginQuery)
//    case withdraw
//    case fetchPost
//    case uploadPost
}

extension Router : TargetType {
    var baseURL: URL {
        return URL(string:APIKey.baseURL.rawValue)!
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/v1/users/login"
        }
    }
    
    var header: [String:String] {
        switch self {
        case .login:
            return [HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue : APIKey.sessacKey.rawValue]
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
        case .login(query: let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            
            return try? encoder.encode(query)
        }
    }
    
    
}
