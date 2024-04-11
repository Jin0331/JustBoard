//
//  TargetType.swift
//  YeogiApa
//
//  Created by JinwooLee on 4/9/24.
//

import Foundation
import Alamofire

// www.naver.com/news/api
protocol TargetType : URLRequestConvertible {
    
    var baseURL : URL { get }
    var method : HTTPMethod { get }
    var path : String { get }
    var header : [String:String] { get }
    var parameter : Parameters? { get }
    var queryItems : [URLQueryItem]? { get }
    var body : Data? { get }
}

extension TargetType {
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string : baseURL.appendingPathComponent(path).absoluteString.removingPercentEncoding!)
        
        var request = URLRequest.init(url: url!)
        
        request.headers = HTTPHeaders(header)
        request.httpMethod = method.rawValue
        request.httpBody = body

        return try URLEncoding.default.encode(request, with: parameter)
    }
}
