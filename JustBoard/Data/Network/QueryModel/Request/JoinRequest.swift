//
//  JoinRequest.swift
//  JustBoard
//
//  Created by JinwooLee on 4/11/24.
//

import Foundation

struct JoinRequest : Encodable {
    let email : String
    let password : String
    let nick : String
//    let phoneNume : String
//    let expert : String
    
    private enum CodingKeys: String, CodingKey {
        case email
        case password
        case nick
//        case phoneNume
//        case expert = "birthDay"
    }
    
}
