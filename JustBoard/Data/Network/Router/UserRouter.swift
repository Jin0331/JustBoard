//
//  UserRouter.swift
//  JustBoard
//
//  Created by JinwooLee on 4/9/24.
//

import Foundation
import Alamofire

enum UserRouter {
    case join(query : JoinRequest)
    case login(query : LoginRequest)
    case refresh(query : RefreshRequest)
    case emailValidation(query : EmailValidationRequest)
}

extension UserRouter : TargetType {
    var baseURL: URL {
        return URL(string:APIKey.baseURLWithVersion())!
    }
    
    var method: HTTPMethod {
        switch self {
        case .join:
            return .post
        case .login:
            return .post
        case .refresh:
            return .get
        case .emailValidation :
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .join:
            return "/users/join"
        case .login:
            return "/users/login"
        case .refresh:
            return "/auth/refresh"
        case .emailValidation:
            return "/validation/email"

        }
    }
    
    var header: [String:String] {
        switch self {
        case .join, .emailValidation :
            return [HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue : APIKey.secretKey.rawValue]
        case .login:
            return [HTTPHeader.contentType.rawValue : HTTPHeader.json.rawValue,
                    HTTPHeader.sesacKey.rawValue : APIKey.secretKey.rawValue]
        case .refresh(let token):
            return [HTTPHeader.authorization.rawValue : token.accessToken,
                    HTTPHeader.sesacKey.rawValue : APIKey.secretKey.rawValue,
                    HTTPHeader.refresh.rawValue : token.refreshToken
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
        case .join(query: let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            
            return try? encoder.encode(query)
        case .login(query: let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            
            return try? encoder.encode(query)
        case .refresh:
            return nil
        case .emailValidation(query: let query):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            
            return try? encoder.encode(query)

        }
    }
    
    
}
